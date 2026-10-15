# A3. Textual use cases

The two use cases that matter most to the MVP walkthrough: **UC-1 Upload dataset** (PP-2) and **UC-8 Explore analysis dataset** (PP-1).

## UC-1 Upload dataset

**Caption:** This use case supports PP-2. It writes the file once and records who uploaded it.

| Row | Detail |
|---|---|
| Actors | Clinical coordinator (Dr. Amina Kamau). Identity provider. Object storage. TRE through Dataset and AuditRecord. |
| Description | The coordinator uploads a spreadsheet or CSV she already has. The TRE stores the bytes write-once in object storage and writes an upload audit row with user, file name, and timestamp. |
| Data | session, fileName, file bytes, userId, timestamp. |
| Stimulus | The coordinator submits the upload form. |
| Response | The TRE returns datasetId and objectId. Status becomes Uploaded. AuditRecord stores action uploaded. |
| Pre/post-conditions | Pre: coordinator has a session. Post: a new object exists in storage and was not an overwrite of an existing objectId. An upload audit row exists. |
| Comments | Soft WORM starts here. Check dataset is included and always runs after a successful store. |
| Alternative flows | 1. Identity verify fails: upload rejected, no object written. 2. Storage rejects overwrite (objectId already exists): upload rejected. 3. Check finds blocking shape errors: dataset becomes CheckFailed and is not processed. |

## UC-8 Explore analysis dataset

**Caption:** This use case supports PP-1. Spreadsheet-style explore after project approval.

| Row | Detail |
|---|---|
| Actors | Researcher (Dr. Ezer Kang). Identity provider. Notification service. TRE through Project, AccessRequest, AnalysisView, Dataset, AuditRecord. |
| Description | After an approved project request, the researcher opens the de-identified analysis dataset, selects columns and rows, applies filters, and sees a table view inside the TRE. |
| Data | session, projectId, datasetId, selectedColumns, rowFilters, viewId. |
| Stimulus | The researcher opens Explore on an approved project dataset and applies a column or row selection. |
| Response | The TRE returns an AnalysisView. An audit row stores action explored. The researcher is notified asynchronously that the view is ready. |
| Pre/post-conditions | Pre: researcher has a session; Project exists; AccessRequest for that project and dataset is Approved; Dataset is AnalysisReady. Post: an AnalysisView is stored under the Project; original vault object is unchanged. |
| Comments | This replaces SPSS for ordinary exploration. UC-9 Create chart builds on the current AnalysisView. |
| Alternative flows | 1. No approved AccessRequest: explore rejected. 2. Dataset not AnalysisReady: explore rejected. 3. Selected column still marked identifier after de-id: view builder rejects that column. |
