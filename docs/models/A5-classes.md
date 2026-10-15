# A5. Domain class diagram

**Caption:** This class diagram supports PP-1, PP-2, PP-3, PP-4, and PP-5. Eleven domain classes (within 6–12) plus three external system classes required by A4.

```mermaid
classDiagram
    direction LR

    class User {
        userId: UUID
        name: String
        email: String
    }
    class Researcher {
        createProject(name) UUID
        requestAccess() UUID
    }
    class Coordinator {
        upload(fileName) UUID
    }
    class Custodian {
        review(requestId) void
    }
    class Project {
        projectId: UUID
        title: String
        ownerId: UUID
        open(projectId) void
        addDataset(datasetId) void
    }
    class Dataset {
        datasetId: UUID
        title: String
        status: String
        originObjectId: String
        analysisObjectId: String
        upload(fileName) UUID
        check() Boolean
        process() void
        deIdentify() String
        prepareAnalysisDataset() void
        isAnalysisReady() Boolean
        readAnalysisObject() Table
    }
    class FieldDefinition {
        fieldName: String
        label: String
        dataType: String
        isIdentifier: Boolean
        acceptedTranslation: String
        accept() void
        acceptTranslation(text) void
    }
    class LocalTerm {
        term: String
        definition: String
        define(text) void
    }
    class AccessRequest {
        requestId: UUID
        purpose: String
        benefit: String
        status: String
        decidedAt: DateTime
        submit(purpose, benefit, projectId, datasetId) UUID
        startReview() void
        approve() void
        deny(reason) void
        isApproved(researcherId, datasetId) Boolean
    }
    class AnalysisView {
        viewId: UUID
        selectedColumns: List
        rowFilters: List
        chartType: String
        select(columns, rowFilters) UUID
        createChart(chartType, xField, yField) UUID
        preview() Table
    }
    class AuditRecord {
        recordId: UUID
        action: String
        at: DateTime
        actorId: UUID
        fileName: String
        record(event) UUID
    }
    class IdentityProvider {
        verify(session) UUID
    }
    class ObjectStorage {
        putNew(fileBytes) String
        get(objectId) Bytes
    }
    class NotificationService {
        notify(userId, message) void
    }

    User <|-- Researcher
    User <|-- Coordinator
    User <|-- Custodian

    Researcher "1" --> "0..*" Project : owns
    Project "1" --> "0..*" AccessRequest : scopes
    Researcher "1" --> "0..*" AccessRequest : submits
    Custodian "1" --> "0..*" AccessRequest : reviews
    AccessRequest "0..*" --> "1" Dataset : targets
    Coordinator "1" --> "0..*" Dataset : uploads
    Dataset "1" *-- "1..*" FieldDefinition : dictionary
    Dataset "1" o-- "0..*" LocalTerm : explains
    AccessRequest "1" *-- "1..*" AuditRecord : history
    Dataset "1" *-- "0..*" AuditRecord : fileHistory
    Project "1" *-- "0..*" AnalysisView : views
    AnalysisView "1" --> "1" Dataset : reads
    Dataset "0..*" --> "1" ObjectStorage : vaultsThrough
    AccessRequest "0..*" --> "1" NotificationService : alertsThrough
```

![Class diagram](A5-classes.png)

**Domain classes (11):** User, Researcher, Coordinator, Custodian, Project, Dataset, FieldDefinition, LocalTerm, AccessRequest, AnalysisView, AuditRecord.  
**External system classes (for A4):** IdentityProvider, ObjectStorage, NotificationService.

**Generalization:** Researcher, Coordinator, Custodian specialize User.  
**Composition:** FieldDefinition dictionary and AuditRecord history die with their whole.  
**Aggregation:** LocalTerm can be reused across datasets from the same site.

Soft WORM: `ObjectStorage.putNew` only; Dataset keeps separate `originObjectId` and `analysisObjectId`. Charts use `AnalysisView.createChart`.

Every A4 message is an operation on the receiving class: `verify`, `upload`, `putNew`, `record`, `check`, `open`, `isApproved`, `select`, `readAnalysisObject`, `notify`.
