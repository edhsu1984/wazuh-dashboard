# evidence: docs/plugins/discover/understand_and_extend_discover.md
Feature: Threat Hunter 為重建攻擊路徑，需於 Discover 中使用 Dataset Explorer 建立暫存 Index Pattern 以進行深度調查
  Background:
    Given Threat Hunter 擁有 security-operations 工作空間與 Discover 探索權限
    And Dataset Explorer 已啟用可瀏覽 INDEX_PATTERN 與 S3 等型別
    And 系統支援暫存 index pattern 快取以避免重複拉取欄位定義

  @domain:xdr @role:hunter @priority:P0 @tenant:multi
  Scenario: Threat Hunter 透過 Dataset Explorer 建立暫存 index pattern
    Given Hunter 選擇 Dataset "logs-*" 並帶有 dataSource 資訊
    When 系統呼叫 fetchFields 並建立 IndexPatternSpec
    Then 暫存 index pattern 被加入快取並供 SearchSource 使用
    And Hunter 可立即在 Discover 檢視對應欄位

  @domain:xdr @role:hunter @priority:P1 @tenant:multi
  Scenario: Threat Hunter 驗證 Dataset 快取重用以縮短調查時間
    Given Hunter 再次選擇相同 Dataset
    When 系統於快取中找到既有暫存 index pattern
    Then 不需重新呼叫 fetchFields 並直接綁定 Query 服務

  @domain:xdr @role:hunter @priority:P1 @tenant:multi
  Scenario: Threat Hunter 處理欄位大量的遠端資料集
    Given Dataset.meta.isFieldLoadAsync 設定為 true
    When Hunter 展開欄位清單
    Then 系統以異步方式載入欄位定義並標示載入狀態

  @domain:xdr @role:hunter @priority:P2 @tenant:multi
  Scenario: Threat Hunter 觀察 Query 物件同步至 SearchSource
    Given Hunter 於 Discover 修改查詢字串
    When QueryStringManager 廣播更新
    Then SearchSource 設定 query 與 dataset.id 並重新擷取結果

  @domain:xdr @role:hunter @priority:P2 @tenant:multi @assumption
  Scenario: Threat Hunter 面對資料集載入失敗的例外狀況
    # 假設：SearchSource 錯誤會提示 Dataset.id 協助排查
    Given fetch() 過程中遠端資料來源回傳錯誤
    When SearchSource 捕捉錯誤
    Then Discover 顯示錯誤訊息包含 Dataset.id 及查詢語言
