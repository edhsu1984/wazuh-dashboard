# evidence: src/plugins/workspace/README.md
Feature: 安全經理為完成事件結案審查，需審核工作空間與 saved object 關聯以確保資產留存與權限一致
  Background:
    Given 安全經理具有列出與更新工作空間的權限
    And Incident Response 與 Security Operations 皆以工作空間分隔資產
    And workspaces 屬性決定儀表板、visualization、data-source 的可視性

  @domain:xdr @role:manager @priority:P0 @tenant:multi
  Scenario: 經理列出所有相關工作空間以確認事件完成狀態
    Given 經理呼叫 POST /api/workspaces/_list 並使用簡易查詢字串 search "incident"
    When API 回傳列表包含每個 workspace 的 features 與 id
    Then 經理確認 incident-response 工作空間已存在且 features 覆蓋 dashboards 與 objects

  @domain:xdr @role:manager @priority:P1 @tenant:multi
  Scenario: 經理檢視單一工作空間確保資產封存
    Given 經理呼叫 GET /api/workspaces/<workspaceId>
    When 回傳結果顯示 features 與描述資訊
    Then 經理確認該工作空間僅保留必要功能並標記為結案

  @domain:xdr @role:manager @priority:P1 @tenant:multi
  Scenario: 經理更新工作空間描述以記錄結案備註
    Given 經理準備 PUT /api/workspaces/<workspaceId> 請求包含 attributes.description="Closed 2024-05-02"
    When API 回傳 success true
    Then 工作空間列表顯示更新後描述供稽核追蹤

  @domain:xdr @role:manager @priority:P2 @tenant:multi
  Scenario: 經理複查共享資源避免未授權揭露
    Given 經理檢視 data-source saved object 的 workspaces 陣列
    When 發現仍指向 incident-response 與其他不相關工作空間
    Then 經理指示移除多餘關聯以符合最小權限

  @domain:xdr @role:manager @priority:P2 @tenant:multi @assumption
  Scenario: 未授權使用者嘗試存取保護中的工作空間
    # 假設：權限驗證於 API 層拒絕未授權查詢
    Given 未授權角色呼叫 GET /api/workspaces/<workspaceId>
    When 系統檢查 permissionModes 不符合要求
    Then 回傳權限錯誤並記錄稽核事件
