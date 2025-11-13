# Dashboard UI Map

This map summarizes the UI surfaces referenced in the behavior scenarios and the primary controls involved in each workflow.

## Workspaces navigation & governance
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Global sidebar → Workspaces | Workspace switcher overlay | Workspace list items, workspace search input | Alert triage: L1 載入指定工作空間；Closure: 未授權使用者嘗試存取保護中的工作空間 |
| Stack Management → Workspaces | Workspace management list | Search field, workspace row link, feature checkboxes | Closure: 經理列出所有相關工作空間；Closure: 經理檢視單一工作空間確保資產封存 |
| Stack Management → Workspaces → Detail panel | Workspace detail flyout | Description text area, Save button | Closure: 經理更新工作空間描述以記錄結案備註 |
| Stack Management → Workspaces → Data Sources tab | Workspace data source assignment | Add data source button, linked data source chips | Data onboarding: 管理員將新資料來源指派至安全工作空間 |

## Saved objects administration
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Stack Management → Saved Objects → Searches | Saved search detail panel | Inspect link, references table | Alert triage: L1 使用 Saved Objects API 取得告警視圖詳細資訊 |
| Stack Management → Saved Objects → Dashboards | Dashboard management table | Duplicate action, Save button, Description field | Alert triage: L1 複製儀表板至另一事件應變工作空間；Response automation: IR 透過 API 更新儀表板描述、IR 發送不合法的 Saved Object 更新 |
| Stack Management → Saved Objects → Data Sources | Data source detail panel | Inspect link, Duplicate action | Alert triage: L1 嘗試複製 data-source 以支援另一租戶；Closure: 經理複查共享資源避免未授權揭露 |
| Incident Response → Automation | Automation status list | Save status button, Delete action | Response automation: IR 建立自動化狀態的 Saved Object；IR 移除過期的 Saved Object 以結案 |

## Data source registration
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Stack Management → Data Sources | Create data source wizard | Create data source button, endpoint & credential fields, Save button | Data onboarding: 系統管理員透過 UI 註冊 OpenSearch 資料來源 |

## Discover analytics workspace
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Global sidebar → Discover | Discover results view | Data source selector, Query editor, Run query button | Detection analytics: L2 分析師以 PPL 查詢跨來源 401 狀態事件；Investigation: Threat Hunter 觀察 Query 物件同步至 SearchSource |
| Discover → Query editor toolbar | Query language selector | Language dropdown (DQL/Lucene/SQL/PPL) | Detection analytics: 分析師依任務切換查詢語言 |
| Discover → Query editor toolbar | Save button | Save action for saved searches | Detection analytics: 分析師以 DQL 保存查詢並發布至儀表板；Detection analytics: 分析師儲存查詢時使用非 DQL/Lucene 語言 |
| Discover → Available fields panel | Field search input, add field toggles | Detection analytics: 分析師調整欄位清單以突顯攻擊指標 |
| Discover → Query editor | Collapse toggle | Detection analytics: 分析師收合查詢編輯器以放大全文檢視 |
| Discover → Date picker | Time range selector | Start/end fields, quick range presets | Detection analytics: 分析師以時間範圍控制確認趨勢 |
| Discover → Query editor action bar | Custom automation button (SQL-only) | Automation trigger button | Response automation: IR 在 Discover 查詢列上加入自訂自動化按鈕；IR 監控自訂按鈕顯示條件 |

## Dataset explorer & temporary patterns
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Discover → Dataset Explorer | Dataset selection modal | Dataset list, Select dataset button | Investigation: Threat Hunter 透過 Dataset Explorer 建立暫存 index pattern；Threat Hunter 驗證 Dataset 快取重用；Threat Hunter 處理欄位大量的遠端資料集 |
| Discover → Dataset Explorer → Field loader | Async field load indicator | Field expand toggle, loading spinner | Investigation: Threat Hunter 處理欄位大量的遠端資料集 |

## Dashboards consumption
| Menu Path | Page/View | Primary Buttons or Links | Referenced Scenarios |
| --- | --- | --- | --- |
| Workspace landing → Dashboards | Dashboard listing | Dashboard cards/links | Alert triage: L1 載入指定工作空間以查看告警儀表板 |

