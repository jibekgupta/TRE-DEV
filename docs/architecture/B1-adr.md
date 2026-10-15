# B1. Architecture decision record

**Caption:** This decision supports PP-1, PP-2, PP-3, PP-4, and PP-5. Drivers are soft WORM upload audit, project-scoped approval, rule-based de-identification, and in-TRE explore/charts.

## 1. Context

Four people build the first version. Users: researcher (creates Projects), clinical coordinator (uploads), custodian (approves). Load is class-project scale.

Sensitive health data must be auditable. Upload must write once and leave an audit row (PP-2). Process must read the original and write a new de-identified analysis object (PP-5). After approval (PP-4), Kang explores columns/rows and builds charts inside the TRE (PP-1). Download stays gated.

## 2. Decision

**Modular monolith.** One application, one deployable, one database.

| Module | Use cases | Owns |
|---|---|---|
| Intake | UC-1, UC-2, UC-3 | Upload, check, local terms, upload audit |
| Process | UC-4 | Read-only de-identify, new analysis object |
| Dictionary / prepare | UC-5 | FieldDefinition, translations |
| Project access | UC-6, UC-7, UC-10 | Project, AccessRequest, gated download |
| Analysis | UC-8, UC-9 | AnalysisView, charts |

Modules call each other in process. Kubernetes deploys this one application.

## 3. Alternatives considered

**Microservices.** Rejected. Approval, project membership, and AnalysisReady must agree in one transaction. Four students should not operate five images.

**Event-driven core.** Rejected. Upload and approval are form waits. Notification is one async HTTPS call, not a broker for every step.

**Serverless only.** Rejected. Process and chart rendering outlive a short function. One long-running app matches the class diagram.

## 4. Performance consequences

Upload latency: object-storage putNew + one audit insert. Process/de-identify is slower and off the custodian click path. Explore/charts read the analysis object and never rewrite the origin. Scale by replicas of the same image. Cache AnalysisReady until process completes. Chart render is synchronous for MVP size.

## 5. Security consequences

Trust boundaries: user network, TRE application, health-data stores, external partners (see B2).

Authentication: `IdentityProvider.verify(session)` (OIDC). No local passwords.  
Authorization: Coordinator uploads; Researcher creates projects, explores, charts, requests download; only Custodian approves.

Soft WORM: `ObjectStorage.putNew` only; process/analysis use `get`. Secrets for DB and translation API come from Kubernetes Secrets (`tre-db`, `tre-api`). Gated download checks `AccessRequest.isApproved` and writes `AuditRecord`.

## 6. Cloud-agnostic plan

| Capability | Open standard | Lock-in accepted |
|---|---|---|
| Run app | Kubernetes | Managed control plane only |
| Sign-in | OpenID Connect | Any OIDC IdP |
| Files | S3-compatible API | putNew/get only |
| Records | SQL / PostgreSQL wire | Ordinary SQL |
| Translation | HTTPS JSON | Provider swappable; accepted text stored by us |
| Notification | HTTPS JSON | Delivery external; audit does not depend on it |

Approval and WORM rules stay in modules we build.
