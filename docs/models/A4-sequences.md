# A4. Sequence diagrams

One sequence per textual use case in A3. Lifelines use `:ClassName`. Filled arrowhead = synchronous. Open arrowhead = asynchronous. Dashed = return.

## UC-1 Upload dataset

**Caption:** This sequence supports PP-2: verify user, write-once store, upload audit, then included check.

```mermaid
sequenceDiagram
    actor Coordinator
    participant IdP as :IdentityProvider
    participant DS as :Dataset
    participant OS as :ObjectStorage
    participant AU as :AuditRecord

    Coordinator->>IdP: verify(session)
    activate IdP
    IdP-->>Coordinator: coordinatorId
    deactivate IdP

    Coordinator->>DS: upload(fileName)
    activate DS
    DS->>OS: putNew(fileBytes)
    activate OS
    alt objectId already exists
        OS-->>DS: rejected
        DS-->>Coordinator: rejected
    else new object
        OS-->>DS: objectId
        deactivate OS
        DS->>AU: record(uploaded)
        activate AU
        AU-->>DS: auditId
        deactivate AU
        DS->>DS: check()
        alt check fails
            DS-->>Coordinator: checkedFailed
        else check passes
            DS-->>Coordinator: datasetId
        end
    end
    deactivate DS
```

![Sequence for UC-1](A4-sequence-uc1.png)

External system: `:ObjectStorage` and `:IdentityProvider` from the context diagram. Guards are in brackets inside `alt`.

## UC-8 Explore analysis dataset

**Caption:** This sequence supports PP-1 after project approval: verify, confirm access, build a column/row view, audit, async notify.

```mermaid
sequenceDiagram
    actor Researcher
    participant IdP as :IdentityProvider
    participant PR as :Project
    participant AR as :AccessRequest
    participant DS as :Dataset
    participant AV as :AnalysisView
    participant AU as :AuditRecord
    participant NS as :NotificationService

    Researcher->>IdP: verify(session)
    activate IdP
    IdP-->>Researcher: researcherId
    deactivate IdP

    Researcher->>PR: open(projectId)
    activate PR
    PR->>AR: isApproved(researcherId, datasetId)
    activate AR
    alt not approved OR dataset not AnalysisReady
        AR-->>PR: rejected
        PR-->>Researcher: rejected
    else approved AND AnalysisReady
        AR-->>PR: approved
        deactivate AR
        Researcher->>AV: select(columns, rowFilters)
        activate AV
        AV->>DS: readAnalysisObject()
        activate DS
        DS-->>AV: analysisRows
        deactivate DS
        AV->>AU: record(explored)
        activate AU
        AU-->>AV: auditId
        deactivate AU
        AV-)NS: notify(researcherId, viewReady)
        activate NS
        NS-->>AV: accepted
        deactivate NS
        AV-->>Researcher: viewId
        deactivate AV
    end
    deactivate PR
```

![Sequence for UC-8](A4-sequence-uc8.png)

`notify` uses an open arrowhead (asynchronous). Returns are dashed. Explore never writes to object storage.
