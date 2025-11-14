# 功能驗收常用名詞 Glossary

## DataView
描述儀表板平台如何將 OpenSearch index pattern 與其他來源的欄位結構標準化的定義檔。DataView 提供名稱、欄位結構、時間欄位設定與對應的資料來源識別，讓分析師與自動化流程能在不同資料湖之間套用相同的查詢邏輯。

## Dataset
Dataset 為序列化後的查詢實體，保留 DataView 的核心欄位、資料來源參照與時間欄位等資訊。它是 Discover、SearchSource 與回應自動化 API 在交換查詢狀態時使用的通用格式，可在不同工作空間間共用並支援遠端資料集。

## Dataset Explorer
Discover 中的 Dataset Explorer 面板提供可瀏覽的資料集清單，讓 Threat Hunter 先挑選 Dataset 再建立暫存 index pattern。此體驗縮短欄位載入時間，並確保調查人員選用經核准的資料來源。

## QueryEditorExtension
QueryEditorExtension 為可插拔的查詢編輯器擴充點，允許團隊在 Discover 的查詢列上加上自訂按鈕、語言控制或自動化捷徑。它將查詢語言、按鈕顯示條件與外部流程整合在單一擴充介面中。

## Saved Objects
Saved Objects 為 OpenSearch Dashboards 儲存設定與資產（儀表板、Saved Search、Data Source 等）的持久層。透過 Saved Objects API，營運團隊可查詢、複製、更新或刪除這些資產，並藉由 workspaces 欄位控制不同團隊的可見性。

## Workspaces
Workspaces 是用來分隔儀表板資產、資料來源與使用者權限的邏輯邊界。每個工作空間代表一個團隊或任務環境，決定哪些 Saved Objects、Data Sources 與 Discover 視圖對成員開放。

## Data Source
Data Source 為平台對外部 OpenSearch 叢集或 S3 Glue 等資料湖的連線設定。它記錄端點、認證與顯示名稱，並以 Saved Object 形式被引用，讓多租戶環境能安全分享或限制特定來源。

## Saved Search
Saved Search 是 Discover 中保存的查詢與欄位配置，讓分析師快速重播常用偵測視角。它在工作空間內共享，可加入儀表板或由自動化流程引用。

## Discover 2.0
Discover 2.0 是分析師互動式查詢介面，支援多種查詢語言、即時視覺化與欄位管理。它與 DataView、Dataset Explorer 與 QueryEditorExtension 深度整合，構成偵測與調查流程的核心工作面板。

## Incident Response Automation
Incident Response Automation 指透過 Saved Objects 與 QueryEditorExtension 將外部流程（如工單或劇本觸發）連結到儀表板操作，確保回應狀態能被紀錄並快速執行。
