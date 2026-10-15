# A2. Use case diagram

**Caption:** This use case diagram supports PP-1, PP-2, PP-3, PP-4, and PP-5. Each use case is tagged with its PP-ID.

```mermaid
flowchart LR
    subgraph actors [" "]
        direction TB
        coordinator(["Clinical coordinator<br/>Dr. Amina Kamau"])
        researcher(["Researcher<br/>Dr. Ezer Kang"])
        translator(["Translation service<br/>system actor"])
        custodian(["Data custodian<br/>Daniel Okoro"])
        notifier(["Notification service<br/>system actor"])
        storage(["Object storage<br/>system actor"])
    end

    subgraph tre ["Global Health TRE"]
        direction TB
        UC1(["UC-1 Upload dataset<br/>PP-2"])
        UC2(["UC-2 Check dataset<br/>PP-2"])
        UC3(["UC-3 Document local term<br/>PP-3"])
        UC4(["UC-4 Process and de-identify<br/>PP-5"])
        UC5(["UC-5 Prepare analysis dataset<br/>PP-1"])
        UC6(["UC-6 Request project access<br/>PP-4"])
        UC7(["UC-7 Review access request<br/>PP-4"])
        UC8(["UC-8 Explore analysis dataset<br/>PP-1"])
        UC9(["UC-9 Create chart<br/>PP-1"])
        UC10(["UC-10 Download analysis dataset<br/>PP-4"])
    end

    coordinator --- UC1
    coordinator --- UC3
    UC1 -.->|include| UC2
    UC3 -.->|extend| UC1
    storage --- UC1
    storage --- UC4
    researcher --- UC5
    researcher --- UC6
    researcher --- UC8
    researcher --- UC9
    researcher --- UC10
    translator --- UC5
    custodian --- UC7
    notifier --- UC7

    style actors fill:none,stroke:none
    style tre stroke-dasharray: 6 4
```

![Use case diagram](A2-use-cases.png)

PlantUML source: `A2-use-cases.puml`.

Three human actors and three system actors. **«include»:** UC-1 → UC-2 (check always runs). **«extend»:** UC-3 → UC-1 (local term only when present). Ten use cases (within 6–10), each tagged with a PP-ID.
