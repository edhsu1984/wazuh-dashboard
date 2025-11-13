# evidence: docs/plugins/discover/getting_started_with_discover.md
# evidence: docs/plugins/discover/understand_and_extend_discover.md
Feature: L2 分析師為提升異常偵測準度，需在 Discover 2.0 中跨資料來源查詢並保存可重複使用的偵測視圖
  Background:
    Given L2 分析師受 RBAC 授權存取 security-operations 工作空間與相關資料來源
    And Discover 啟用多資料型態與 Query Enhancements 支援 DQL、Lucene、SQL 與 PPL
    And 分析師已將時間範圍鎖定於過去 24 小時以聚焦最新事件

  @domain:xdr @role:l2 @priority:P0 @tenant:multi
  Scenario: L2 分析師以 PPL 查詢跨來源 401 狀態事件以供進一步偵測
    Given 分析師於 Discover 選擇資料來源 "Local OpenSearch" 並指定時間欄位 timestamp
    When 分析師輸入 PPL 查詢 "source = my_logs | where status = \"401\"" 並執行
    Then 結果表格呈現僅含 status 401 的文件並更新事件數視圖
    And 直方圖依據時間範圍顯示事件分布供趨勢分析

  @domain:xdr @role:l2 @priority:P1 @tenant:multi
  Scenario Outline: 分析師依任務切換查詢語言以產生對應偵測視角
    Given 分析師於 Discover 的語言選擇器選擇 <language>
    When 分析師輸入符合語法的查詢並執行
    Then Query Editor 顯示對應語法提示並允許保存查詢為 Saved Search

    Examples:
      | language |
      | DQL      |
      | Lucene   |
      | SQL      |

  @domain:xdr @role:l2 @priority:P2 @tenant:multi
  Scenario: 分析師以 DQL 保存查詢並發布至儀表板供持續監控
    Given 分析師執行查詢後點擊 Save 並輸入名稱 "High Severity Access"
    When 分析師確認保存且語言為 DQL
    Then Saved Search 於 workspace 中可用並能加入 Dashboard 面板

  @domain:xdr @role:l2 @priority:P2 @tenant:multi
  Scenario: 分析師調整欄位清單以突顯攻擊指標
    Given 分析師展開 Available Fields 並搜尋「clientip」欄位
    When 分析師將「clientip」與「response_time」加入結果表格
    Then 文件表格顯示新增欄位並支援排序與過濾

  @domain:xdr @role:l2 @priority:P1 @tenant:multi
  Scenario: 分析師收合查詢編輯器以放大全文檢視
    Given 分析師於 Query Editor 右上角點擊收合按鈕
    When 編輯器收合後分析師檢視長文件
    Then 結果表格區域高度增加以利調查

  @domain:xdr @role:l2 @priority:P2 @tenant:multi
  Scenario: 分析師以時間範圍控制確認趨勢
    Given 分析師使用日期選擇器改為 ISO 8601 區間 2024-05-01T00:00:00Z 至 2024-05-02T00:00:00Z
    When 查詢重新執行
    Then 圖表與表格僅顯示指定時間窗的事件

  @domain:xdr @role:l2 @priority:P2 @tenant:multi
  Scenario: 分析師儲存查詢時使用非 DQL/Lucene 語言
    Given 分析師以 SQL 語言保存查詢
    When 分析師嘗試將該 Saved Search 加入 Dashboard
    Then 系統阻止新增並提示僅支援 DQL 或 Lucene
