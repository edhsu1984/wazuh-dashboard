# evidence: docs/plugins/data/datasets/data_views.md
# evidence: docs/plugins/discover/understand_and_extend_discover.md
Feature: 資料工程師為了提供跨來源一致查詢，需維護 DataView 與 Dataset 正規化模型給偵測團隊使用
  Background:
    Given 平台以 DataView 類別描述 index-pattern 與 S3 等異質來源
    And Dataset 序列化物件用於查詢狀態與 URL 儲存，並保持與既有 index-pattern API 相容
    And DataSource 物件記錄遠端端點、型別與顯示名稱供 Discover 及搜尋服務使用

  @domain:xdr @role:manager @priority:P0 @tenant:multi
  Scenario Outline: 資料工程師將 OpenSearch Index Pattern 序列化成 Dataset 供查詢服務使用
    Given 已建立含欄位定義與 dataSourceRef 的 DataView 物件 <dataViewId>
    When 工程師呼叫 DataView.toDataset()
    Then 取得的 Dataset 包含 id、title、type 與 timeFieldName
    And Dataset.dataSource 以 dataSourceRef.id 與名稱呈現遠端叢集資訊

    Examples:
      | dataViewId                                 |
      | aaf88e10-5e86-11f0-a5d2-cdd32f30059b       |

  @domain:xdr @role:manager @priority:P1 @tenant:multi
  Scenario: 工程師將 S3 Glue 表格映射為 Dataset 以支援遠端查詢
    Given S3 型 DataView 包含 id "7d5c3e1c-ae5f-11ee-9c91-1357bd240003::mys3.defaultDb.table1" 與欄位 order_date
    When 工程師執行 toDataset() 並標示為遠端資料集
    Then Dataset.isRemoteDataset 為 true 並保留資料來源型別 "S3_GLUE"
    And Dataset.timeFieldName 設定為 "order_date" 供時間視覺化使用

  @domain:xdr @role:manager @priority:P2 @tenant:multi @assumption
  Scenario: 臨時 Index Pattern 建立失敗時通知工程師處理欄位載入錯誤
    # 假設：fetchFields 回傳錯誤時會拋出例外供監控
    Given Dataset.type 非 INDEX_PATTERN 且需透過 fetchFields 取得欄位資訊
    When fetchFields 回傳錯誤導致暫存 index pattern 無法建立
    Then 系統拋出 "Failed to load dataset" 錯誤訊息並記錄 Dataset.id 以利追蹤
