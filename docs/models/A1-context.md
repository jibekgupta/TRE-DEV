# A1. Context diagram

**Caption:** This context diagram supports PP-1, PP-2, PP-3, PP-4, and PP-5 by showing the TRE between the three personas and the external systems it uses.

```mermaid
flowchart TB
    researcher["Researcher<br/>Dr. Ezer Kang"]
    coordinator["Clinical coordinator<br/>Dr. Amina Kamau"]
    custodian["Data custodian<br/>Daniel Okoro"]

    subgraph boundary["TRE system boundary"]
        tre["Global Health TRE"]
    end

    idp["Identity provider"]
    storage["Object storage<br/>write-once vault"]
    translate["Translation service"]
    notify["Notification service"]

    researcher --- tre
    coordinator --- tre
    custodian --- tre
    tre --- idp
    tre --- storage
    tre --- translate
    tre --- notify

    style boundary stroke-dasharray: 6 4
```

![Context diagram](A1-context.png)

## Boundary justification

The TRE builds upload audit, project-scoped access, de-identification into a new analysis object, spreadsheet-style explore, charts, and gated download records. Sign-in, the vault, machine translation, and notification delivery are integrated. We chose to build the approval and audit rules; we chose to integrate the identity provider instead of storing passwords ourselves.
