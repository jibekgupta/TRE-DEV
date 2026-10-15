# B2. Architecture diagram

**Caption:** This architecture supports PP-1, PP-2, PP-3, PP-4, and PP-5. Solid arrows are synchronous; the dotted arrow is async notification.

Legend: box = client, service, or external system. Cylinder = data store. Dashed box = trust boundary.

```mermaid
flowchart TB
    subgraph users ["Trust boundary: user network"]
        researcher["Researcher client<br/>Dr. Ezer Kang"]
        coordinator["Coordinator client<br/>Dr. Amina Kamau"]
        custodian["Custodian client<br/>Daniel Okoro"]
    end

    subgraph appZone ["Trust boundary: TRE application"]
        app["TRE application<br/>Intake, Process,<br/>Dictionary, Project access,<br/>Analysis"]
    end

    subgraph dataZone ["Trust boundary: health data"]
        db[("PostgreSQL<br/>metadata + audit")]
        files[("Object storage<br/>write-once vault")]
    end

    subgraph partners ["Trust boundary: external partners"]
        idp["Identity provider"]
        mt["Translation service"]
        ns["Notification service"]
    end

    researcher -->|HTTPS sync| app
    coordinator -->|HTTPS sync| app
    custodian -->|HTTPS sync| app
    app -->|SQL/TLS sync| db
    app -->|HTTPS putNew write-only| files
    app -->|HTTPS get read-only| files
    app -->|HTTPS sync OIDC| idp
    app -->|HTTPS sync| mt
    app -.->|HTTPS async| ns
```

![Architecture diagram](B2-architecture.png)

Modules match A5 clusters. External systems match A1. Every trust-boundary crossing has a protocol label. Authentication for the OIDC arrow and authorization for roles are in B1 section 5.
