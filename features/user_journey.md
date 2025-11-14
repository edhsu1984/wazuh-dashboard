# XDR 使用者旅程：從資料接入到結案

下列流程描繪 SOC 團隊在 Wazuh Dashboard 上完成端到端偵測與回應的時間順序。每一階段都指出主要負責的角色、需備條件、對應的自動化情境，以及交棒給下一位角色的時機。

## 1. 資料接入（Data Onboarding）
- **主要角色**：系統管理員（Manager）
- **情境腳本**：[01-data-onboarding-admin-multi-datasource.feature](./data-onboarding/01-data-onboarding-admin-multi-datasource.feature)
- **必要條件**：
  - 平台需以多租戶模式部署並啟用 `data_source.enabled` 與 `workspace.enabled` 設定，才能集中管理跨叢集來源。
  - 管理員必須具備 Stack Management > Data Sources 的操作權限與既有安全工作空間可指派資料來源。
- **參考資源**：
  - [Multi-data source 高階設計](../docs/multi-datasource/high_level_design.md)
  - [Discover 入門指南（確認資料來源可用）](../docs/plugins/discover/getting_started_with_discover.md)
  - [Workspace 模組說明（saved object 關聯）](../src/plugins/workspace/README.md)
- **交棒時機**：資料來源建立並指派到「security-operations」工作空間後，即交由資料工程師設定統一的資料檢索模型。

## 2. 資料建模（Data Modeling）
- **主要角色**：資料工程師（Manager 權限）
- **情境腳本**：[02-data-modeling-data-engineer-data-views.feature](./data-modeling/02-data-modeling-data-engineer-data-views.feature)
- **必要條件**：
  - 已有具備欄位定義與 `dataSourceRef` 的 DataView 物件，才能序列化為 Dataset。
  - 工程師必須存取異質來源（OpenSearch、S3 等）以驗證遠端 Dataset 欄位與快取機制。
- **參考資源**：
  - [DataView 與 Dataset 模型文件](../docs/plugins/data/datasets/data_views.md)
  - [Discover 深入指南（瞭解查詢服務如何使用 Dataset）](../docs/plugins/discover/understand_and_extend_discover.md)
- **交棒時機**：當 Dataset 與 DataView 已就緒，並可由 Discover 查詢使用時，即交給 L2 分析師進行偵測分析。

## 3. 偵測分析（Detection Analytics）
- **主要角色**：L2 分析師
- **情境腳本**：[03-detection-analytics-l2-discover.feature](./detection-analytics/03-detection-analytics-l2-discover.feature)
- **必要條件**：
  - 分析師需被授權存取目標工作空間與相關資料來源。
  - Discover 必須啟用多語言查詢（DQL、Lucene、SQL、PPL）與時間範圍控制功能，以便建構持續偵測視圖。
- **參考資源**：
  - [Discover 入門指南（查詢介面操作）](../docs/plugins/discover/getting_started_with_discover.md)
  - [Discover 深入指南（儲存與分享偵測視圖）](../docs/plugins/discover/understand_and_extend_discover.md)
- **交棒時機**：已保存的 Saved Search 或儀表板視圖提供給 L1 分流人員，用於日常告警分流與指派。

## 4. 告警分流（Alert Triage）
- **主要角色**：L1 分流人員
- **情境腳本**：[04-alert-triage-l1-workspace.feature](./alert-triage/04-alert-triage-l1-workspace.feature)
- **必要條件**：
  - L1 需加入對應工作空間並具備 Saved Objects 讀寫權限，才能查閱與複製偵測視圖。
  - Saved Search 與儀表板必須正確標記 workspaces 屬性，才會出現在分流介面。
- **參考資源**：
  - [Workspace 模組說明（權限與 saved object 關聯）](../src/plugins/workspace/README.md)
  - [Saved Objects API 規格（查詢與複製視圖）](../docs/openapi/saved_objects/saved_objects.yml)
- **交棒時機**：當 L1 將重大告警與相關視圖指派給 Threat Hunter，調查階段隨即展開。

## 5. 深入調查（Investigation）
- **主要角色**：Threat Hunter
- **情境腳本**：[05-investigation-hunter-dataset-exploration.feature](./investigation/05-investigation-hunter-dataset-exploration.feature)
- **必要條件**：
  - Threat Hunter 需具備 Discover 與 Dataset Explorer 使用權限。
  - 系統應啟用暫存 index pattern 快取與非同步欄位載入，以支援大型遠端資料集。
- **參考資源**：
  - [Discover 深入指南（Dataset Explorer 與查詢同步）](../docs/plugins/discover/understand_and_extend_discover.md)
- **交棒時機**：調查結果與暫存查詢需回饋給 Incident Response 指揮，啟動或調整自動化流程。

## 6. 回應自動化（Response Automation）
- **主要角色**：Incident Response 指揮（IR）
- **情境腳本**：[06-response-automation-ir-saved-objects.feature](./response-automation/06-response-automation-ir-saved-objects.feature)
- **必要條件**：
  - IR 團隊需具備 `/api/saved_objects` 讀寫權限與 Discover Query Editor 擴充權限。
  - 已建立的儀表板與 Saved Search 應能反映自動化劇本狀態，並可由自訂按鈕觸發外部流程。
- **參考資源**：
  - [Saved Objects API 規格（自動化狀態管理）](../docs/openapi/saved_objects/saved_objects.yml)
  - [Query Editor 擴充指南](../docs/plugins/data/query-editor-enhancements.md)
- **交棒時機**：當自動化執行結果與紀錄更新完成，將稽核與結案資訊回傳給安全經理審閱。

## 7. 結案稽核（Closure）
- **主要角色**：安全經理（Manager）
- **情境腳本**：[07-closure-manager-workspace-audit.feature](./closure/07-closure-manager-workspace-audit.feature)
- **必要條件**：
  - 經理需具備列出與更新工作空間、檢視 data-source 關聯的 API 權限。
  - Incident Response 與 Security Operations 工作空間必須區隔，確保資產留存與最小權限原則。
- **參考資源**：
  - [Workspace 模組說明（結案稽核流程）](../src/plugins/workspace/README.md)
  - [Saved Objects API 規格（確認關聯與權限）](../docs/openapi/saved_objects/saved_objects.yml)
- **交棒時機**：當工作空間描述與資產關聯完成審查並記錄結案備註，該事件生命周期終結；如需重新開啟，流程將再次從資料接入或偵測調整開始。
