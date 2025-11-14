# Context: Incident Response 指揮結合 Saved Objects API 與 QueryEditorExtension，自動化記錄與觸發回應劇本。
# 參考 glossary：[Incident Response Automation](../glossary.md#incident-response-automation)、[Saved Objects](../glossary.md#saved-objects)、[QueryEditorExtension](../glossary.md#queryeditorextension)。
# evidence: docs/openapi/saved_objects/saved_objects.yml
# evidence: docs/plugins/data/query-editor-enhancements.md
Feature: 事件應變指揮為加速回應自動化，需結合 Saved Objects API 與查詢編輯器擴充來觸發作業與紀錄處置狀態
  Background:
    Given Incident Response 團隊擁有 /api/saved_objects 讀寫權限與 Discover 查詢擴充權限
    And 工作空間內已建立紀錄自動化流程的儀表板與 Saved Search
    And Query Editor 支援自訂按鈕以觸發外部自動化流程

  @domain:xdr @role:ir @priority:P0 @tenant:multi
  Scenario: IR 透過 API 更新儀表板描述以記錄自動化劇本版本
    Given IR 對 /api/saved_objects/dashboard/<dashboardId> 發出 GET 以取得現有版本
    When IR 使用 PUT 請求更新 description 與 references 以指向最新劇本
    Then API 回傳 200 並顯示更新後的 version
    And 儀表板於工作空間中呈現新的描述文字
    # UI mapping: Stack Management > Saved Objects > Dashboards > Edit 會先以 GET 載入細節，按下 Save 後觸發 PUT /api/saved_objects/dashboard/<dashboardId>。
    # Business trigger: 指揮官更新儀表板描述以同步自動化劇本版本號。
    # UI confirmation: 儀表板列表與儀表板頁面同步顯示更新描述。

  @domain:xdr @role:ir @priority:P1 @tenant:multi
  Scenario: IR 建立自動化狀態的 Saved Object 並關聯工作空間
    Given IR 對 /api/saved_objects/automation/<id>?overwrite=true 發送 POST 請求
    And 請求中包含 attributes.status="completed" 與 workspaces ["security-operations"]
    When API 回應成功
    Then 工作空間成員可查詢該 automation saved object 並檢視狀態欄位
    # UI mapping: Incident Response > Automation 設定頁的 "Save status" 按鈕提交 POST /api/saved_objects/automation/<id>?overwrite=true。
    # Business trigger: 指揮流程完成後，IR 團隊在介面中紀錄執行結果。
    # UI confirmation: Automation 狀態列表顯示新紀錄並標記 completed。

  @domain:xdr @role:ir @priority:P1 @tenant:multi
  Scenario: IR 在 Discover 查詢列上加入自訂自動化按鈕
    Given IR 的插件註冊 QueryEditorExtension 並回傳 getActionBarButtons 元件
    When 偵測人員於 Discover 視圖載入該插件
    Then 查詢結果工具列出現自動化按鈕並可呼叫外部流程

  @domain:xdr @role:ir @priority:P2 @tenant:multi
  Scenario: IR 監控自訂按鈕顯示條件
    Given QueryEditorExtensionConfig.isEnabled$ 僅於語言為 SQL 時回傳 true
    When 使用者切換至其他語言
    Then 自動化按鈕從 UI 隱藏以避免誤觸

  @domain:xdr @role:ir @priority:P2 @tenant:multi
  Scenario: IR 移除過期的 Saved Object 以結案
    Given IR 對 /api/saved_objects/automation/<id> 發送 DELETE 請求
    When API 回傳成功
    Then 該 automation saved object 從工作空間列表移除
    # UI mapping: Automation 狀態列表的刪除按鈕呼叫 DELETE /api/saved_objects/automation/<id>。
    # Business trigger: 回應流程結束後移除舊紀錄避免混淆。
    # UI confirmation: 列表刷新後項目消失並顯示成功 toast。

  @domain:xdr @role:ir @priority:P2 @tenant:multi @assumption
  Scenario: IR 發送不合法的 Saved Object 更新
    # 假設：缺少 attributes 時 API 回傳 400
    Given IR 對 /api/saved_objects/dashboard/<dashboardId> 發送 PUT 且缺少 attributes
    When API 驗證請求
    Then 回傳 400 Bad Request 以提示必填欄位
    # UI mapping: Dashboards 編輯視圖的 Save 動作若表單缺少必填欄位仍會送出 PUT /api/saved_objects/dashboard/<dashboardId>，後端回傳 400。
    # Business trigger: 使用者誤刪描述或名稱欄位後嘗試保存。
    # UI confirmation: 表單顯示錯誤提示並維持在編輯狀態供補件。
