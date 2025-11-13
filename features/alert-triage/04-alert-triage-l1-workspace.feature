# evidence: src/plugins/workspace/README.md
# evidence: docs/openapi/saved_objects/saved_objects.yml
Feature: L1 分流人員為確保告警處理一致性，需在工作空間中取得並複製 Saved Search 以支援多隊伍調閱
  Background:
    Given L1 分流人員加入 "security-operations" 工作空間並可讀取對應 saved objects
    And 告警儀表板與 Saved Search 已透過 workspaces 屬性關聯此工作空間
    And 事件資料使用 data-source saved objects 於多租戶中共用

  @domain:xdr @role:l1 @priority:P0 @tenant:multi
  Scenario: L1 載入指定工作空間以查看告警儀表板
    Given L1 於左側選單選擇 Workspaces 並進入 "security-operations"
    When L1 開啟 Dashboards 功能
    Then 僅顯示屬於該工作空間的儀表板 saved objects
    And 面板資料來源受限於已指派的 data-source

  @domain:xdr @role:l1 @priority:P1 @tenant:multi
  Scenario: L1 使用 Saved Objects API 取得告警視圖詳細資訊
    Given L1 對 /api/saved_objects/search 發出查詢以搜尋 type "search" 且關鍵字 "High Severity Access"
    When API 回傳 200 並包含 workspaces 欄位
    Then L1 確認該 Saved Search 屬於 "security-operations" 並記錄其 references 列表
    # UI mapping: Stack Management > Saved Objects > Searches > Inspect 透過 POST /api/saved_objects/search 取得搜尋結果與工作空間欄位。
    # Business trigger: L1 需確認已保存的查詢是否與工作空間綁定以支援交班。
    # UI confirmation: Saved Objects 詳細頁顯示 workspaces 與 references 欄位供複製前檢查。

  @domain:xdr @role:l1 @priority:P1 @tenant:multi
  Scenario: L1 複製儀表板至另一事件應變工作空間
    Given L1 於 Saved Objects 管理介面選擇目標儀表板並執行 Duplicate
    When L1 指定目標工作空間 "incident-response"
    Then 系統建立新 dashboard saved object 並重新產生 id
    And 依需求複製相依的 visualizations 與 index-patterns
    # UI mapping: Stack Management > Saved Objects > Dashboards > Duplicate 觸發 POST /api/saved_objects/_bulk_create 以建立新儀表板並設定 workspaces。
    # UI confirmation: 複本出現在 Saved Objects 列表且在 incident-response 工作空間的 Dashboards 中可見。

  @domain:xdr @role:l1 @priority:P2 @tenant:multi @assumption
  Scenario: L1 嘗試複製 data-source 以支援另一租戶
    # 假設：data-source 需手動指派，Duplicated 將被拒絕
    Given L1 於 Saved Objects 列表選擇 data-source 類型
    When L1 選擇 Duplicate 功能
    Then 系統顯示無法複製 data-source 並提示需於目標工作空間手動指派
    # UI mapping: Stack Management > Saved Objects > Data Sources > Duplicate 仍呼叫 POST /api/saved_objects/_bulk_create，但伺服器回傳錯誤以防止複製。
    # UI confirmation: Duplicate 對話框顯示錯誤訊息並指向 Workspaces 設定進行手動指派。
