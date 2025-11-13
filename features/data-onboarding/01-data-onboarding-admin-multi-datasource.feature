# evidence: docs/multi-datasource/high_level_design.md
# evidence: docs/plugins/discover/getting_started_with_discover.md
# evidence: src/plugins/workspace/README.md
Feature: SOC 系統管理員為了集中治理多叢集資料接入，需在多租戶儀表板中註冊資料來源並指派至安全工作空間
  Background:
    Given 平台部署於 multi-tenant single control-plane 並啟用 data_source.enabled 及 workspace.enabled 設定
    And 管理索引「.kibana」儲存 metadata，遠端使用者資料索引位於 OpenSearch 叢集 https://198.51.100.10:9200
    And 系統有安全營運工作空間 "use-case-security-analytics" 供 SOC 隊伍使用
    And RBAC 賦予系統管理員可建立資料來源與更新工作空間的權限

  @domain:xdr @role:manager @priority:P0 @tenant:multi
  Scenario Outline: 系統管理員透過 UI 註冊 OpenSearch 資料來源供跨節點偵測使用
    Given 管理員於 Stack Management > Data Sources 介面選擇 Create data source
    And 管理員輸入資料來源名稱 <name> 與端點 <endpoint> 並設定 Basic 認證帳號 <username>
    When 管理員確認保存資料來源
    Then 系統建立 data-source 型 saved object 並以對稱金鑰加密認證資訊
    And 該資料來源可供建立 index pattern 與 Discover 視圖

    Examples:
      | name                | endpoint                    | username   |
      | Local OpenSearch    | https://198.51.100.10:9200  | soc_admin  |
      | Edge Collector A    | https://203.0.113.25:9200   | edge_sync  |

  @domain:xdr @role:manager @priority:P0 @tenant:multi
  Scenario: 管理員將新資料來源指派至安全工作空間供分析師瀏覽
    Given 管理員於 Workspaces 設定頁選擇 "security-operations" 工作空間
    When 管理員在 Data Sources 分頁加入剛建立的 "Local OpenSearch" 資料來源
    Then 工作空間關聯列表包含該資料來源識別碼
    And 已授權至該工作空間的成員可在 Discover 介面選擇此資料來源

  @domain:xdr @role:manager @priority:P1 @tenant:multi @assumption
  Scenario: 管理員嘗試在存在遠端資料來源時停用多資料來源功能
    # 假設：部署流程會於啟動時驗證設定與既有 saved object
    Given 已有至少一個 data-source saved object 參照遠端叢集
    When 管理員修改設定將 data_source.enabled 設為 false 後重新啟動服務
    Then 儀表板啟動程序失敗並提示需先移除資料來源方可停用功能
