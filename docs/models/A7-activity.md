# A7. Activity diagram

**Caption:** This activity supports the walkthrough upload → audit → analyze under a project (PP-2, PP-5, PP-4, PP-1).

```mermaid
flowchart TB
    subgraph coordLane ["Swimlane: Coordinator - Dr. Amina Kamau"]
        startNode([Start]) --> uploadAct[upload]
    end

    subgraph treLane ["Swimlane: TRE"]
        writeVault[putNew to object storage]
        auditUpload[record uploaded]
        checkGate{check ok?}
        rejectStop([Stop])
        processAct[process read-only]
        deIdAct[deIdentify new analysis object]
        readyAct[mark AnalysisReady]
        decisionFork{{fork}}
        recordDecision[record decision]
        decisionJoin{{join}}
        accessGate{approved and AnalysisReady?}
        denyStop([Stop])
        buildView[select columns and rows]
        chartOpt{create chart?}
        chartAct[createChart]
        doneNode([End])
    end

    subgraph researchLane ["Swimlane: Researcher - Dr. Ezer Kang"]
        createProj[create Project]
        requestAct[request project access]
        exploreAct[explore analysis dataset]
    end

    subgraph custodianLane ["Swimlane: Data custodian - Daniel Okoro"]
        reviewAct[startReview]
        decisionGate{approve or deny?}
        approveAct[approve]
        denyAct[deny]
    end

    subgraph notifyLane ["Swimlane: Notification service"]
        notifyAct[notify researcher]
    end

    uploadAct --> writeVault --> auditUpload --> checkGate
    checkGate -->|no| rejectStop
    checkGate -->|yes| processAct --> deIdAct --> readyAct --> createProj --> requestAct --> reviewAct
    reviewAct --> decisionGate
    decisionGate -->|deny| denyAct --> decisionFork
    decisionGate -->|approve| approveAct --> decisionFork
    decisionFork --> recordDecision --> decisionJoin
    decisionFork --> notifyAct --> decisionJoin
    decisionJoin --> accessGate
    accessGate -->|no| denyStop
    accessGate -->|yes| exploreAct --> buildView --> chartOpt
    chartOpt -->|yes| chartAct --> doneNode
    chartOpt -->|no| doneNode
```

![Activity diagram](A7-activity.png)

Swimlanes map to A1 actors/systems. Decisions use guards. After the custodian decides, recording the decision and notifying the researcher run in parallel (fork/join). Explore and optional chart run only when access is approved and the dataset is AnalysisReady.
