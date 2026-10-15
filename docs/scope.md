# 0. Pain-point scope and traceability

**Product:** Global Health Trusted Research Environment (TRE)
**Course:** Advanced Software Engineering - Model and Architect Your MVP
**Team:** Anu, Ade, Manushi, Jibek

The MVP vaults a raw upload once, audits it, de-identifies into a new analysis object, and lets Dr. Ezer Kang explore that object under a Project after Daniel Okoro approves. Analysis is spreadsheet/BI-style inside the TRE (columns, rows, charts). SPSS is not required. Soft WORM: write once, read many.

## Personas in this MVP

| Persona | Role in the MVP |
|---|---|
| Dr. Ezer Kang | Medical researcher. Creates Projects, requests access, explores and charts inside the TRE, may download only when approved. |
| Dr. Amina Kamau | Clinical research coordinator. Uploads raw study data and documents local terms. |
| Daniel Okoro | Data custodian. Approves or denies project-scoped access and can see who asked, why, and what was decided. |

## Traceability table

| ID | Persona | Pain point | MVP capability | Use case(s) | Success signal |
|---|---|---|---|---|---|
| PP-1 | Dr. Ezer Kang | He depends on SPSS and hand cleanup before he can explore a study file. | After approval he explores the de-identified analysis dataset inside the TRE: select columns and rows, filter, build charts (bar, line, scatter, pie). Prepare includes dictionary and accepted translations. | UC-5 Prepare analysis dataset; UC-8 Explore analysis dataset; UC-9 Create chart | He finishes one explore session and one chart on an approved project dataset without leaving the TRE. |
| PP-2 | Dr. Amina Kamau | Study data sits unused because cleanup takes too long, and uploads are not safely vaulted. | She uploads a CSV/spreadsheet write-once to object storage. An audit row stores user, file name, and timestamp. Originals are not overwritten. | UC-1 Upload dataset; UC-2 Check dataset | She gets a check report in one sitting, and an upload audit row exists for a new object id. |
| PP-3 | Dr. Amina Kamau | Local terms differ by site and get misunderstood. | She marks a local term and writes its definition before the dataset can be prepared. | UC-3 Document local term | A flagged term cannot be prepared without a definition. |
| PP-4 | Daniel Okoro | Sensitive data can be reused with no record of who, why, or benefit, including downloads. | Access is requested per Project with purpose and benefit. He approves or denies. Download is gated and audited. | UC-6 Request project access; UC-7 Review access request; UC-10 Download analysis dataset | He can list project, requester, purpose, benefit, decision, and timestamp. A download requires approval and creates an audit row. |
| PP-5 | All / Safe data | Identifiers in raw uploads make research use unsafe. | Process reads the vaulted original only. Rule-based de-identification writes a new analysis object. The origin object id is unchanged. | UC-4 Process and de-identify dataset | Explore, charts, and download use the de-identified object only. |

## Reserved use cases

| ID | Name | Pain point | Relationship |
|---|---|---|---|
| UC-1 | Upload dataset | PP-2 | Write-once store + upload audit. |
| UC-2 | Check dataset | PP-2 | «include» from UC-1. |
| UC-3 | Document local term | PP-3 | «extend» on UC-1 when a local term appears. |
| UC-4 | Process and de-identify dataset | PP-5 | Read-only on original; new analysis object. |
| UC-5 | Prepare analysis dataset | PP-1 | Dictionary + accepted translations. |
| UC-6 | Request project access | PP-4 | Kang: purpose + benefit for one Project and Dataset. |
| UC-7 | Review access request | PP-4 | Custodian approve/deny. |
| UC-8 | Explore analysis dataset | PP-1 | Select columns/rows, filter, table view. |
| UC-9 | Create chart | PP-1 | Bar, line, scatter, or pie from the current view. |
| UC-10 | Download analysis dataset | PP-4 | Gated download + audit. |

## Out of scope

- Full Google Sheets / Power BI product, notebooks, or arbitrary R/SPSS scripts.
- Strong privacy methods (NLP redaction, k-anonymity, differential privacy).
- Cultural instrument redesign beyond accepted translation.
- Qualitative coding; hospital operations / ministry reporting.
- Automatic approval; hard storage immutability hardware.
- Sharing by email or any path that skips project access approval.

## Walkthrough thread

**Upload → audit → analyze under a project:** UC-1 → UC-4 → UC-6 → UC-7 → UC-8 / UC-9.

## Architecture constraint

Modular monolith. Upload path write-only to object storage; process and analysis read-only on vaulted originals. PostgreSQL holds metadata, projects, requests, views, and audit rows.
