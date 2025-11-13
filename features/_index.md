# Wazuh Dashboard XDR/SIEM 功能驗收索引

## 人物誌與權限
- **Manager（安全經理）**：具備多租戶設定、資料來源維運與工作空間稽核權限。對應 `@role:manager`。
- **L1（告警分流人員）**：可存取指派的工作空間、檢視與複製儀表板及 Saved Search。對應 `@role:l1`。
- **L2（進階分析師）**：可於 Discover 進行跨來源查詢、保存偵測視圖。對應 `@role:l2`。
- **Hunter（Threat Hunter）**：可使用 Dataset Explorer、建立暫存 Index Pattern 深度探索。對應 `@role:hunter`。
- **IR（Incident Response 指揮）**：擁有 Saved Objects API 讀寫與查詢編輯器擴充權限以整合自動化。對應 `@role:ir`。

## 功能模組與 Feature 對照
- **端到端使用者旅程**：[features/user_journey.md](./user_journey.md)
- **01 資料接入**：`features/data-onboarding/01-data-onboarding-admin-multi-datasource.feature`
- **02 資料建模與正規化**：`features/data-modeling/02-data-modeling-data-engineer-data-views.feature`
- **03 偵測與分析**：`features/detection-analytics/03-detection-analytics-l2-discover.feature`
- **04 告警分流**：`features/alert-triage/04-alert-triage-l1-workspace.feature`
- **05 調查與追蹤**：`features/investigation/05-investigation-hunter-dataset-exploration.feature`
- **06 回應自動化**：`features/response-automation/06-response-automation-ir-saved-objects.feature`
- **07 結案與稽核**：`features/closure/07-closure-manager-workspace-audit.feature`

## 標籤體系
- `@domain:xdr`：表示該情境屬於 XDR/SIEM 領域。
- `@role:<persona>`：依據上述人物誌指定使用者角色與權限邊界。
- `@priority:P0`：關鍵主流程（資料導入、正規化、偵測、分流、調查、回應、結案）。
- `@priority:P1`：主要支援流程（跨工作空間協作、狀態同步、回應自動化操作）。
- `@priority:P2`：擴充或例外流程（視覺化微調、異常處理、稽核與權限驗證）。
- `@tenant:<single|multi>`：說明租戶模型，預設多租戶以符合 SOC 隊伍需求。
- `@assumption`：代表需求假設，待與工程團隊確認實作細節。
- 可依需求增添 `@mitre:*`, `@logsource:*`, `@compliance:*` 等延伸標籤於後續工作。

## 優先度準則
- **P0**：若缺失將中斷端到端偵測、調查與回應流程。
- **P1**：影響跨角色協同或自動化效率，需於主流程穩定後優先補強。
- **P2**：屬於體驗優化、錯誤處理或管控需求，可排入後續迭代。
