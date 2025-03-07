# FilterSearchPicker

FilterSearchPicker 是一個使用 Swift 開發的篩選搜尋頁面列表選擇器，結合了 Combine 與 Diffable Data Source 技術。

## 功能特點

- **結合 Combine 與 Diffable Data Source**：利用 Swift 的現代框架實現高效、響應式的資料處理與更新。
- **篩選與搜尋功能**：提供即時的清單篩選與搜尋功能，提升使用者體驗。

## 安裝與使用

### 1. 克隆此專案

```bash
git clone https://github.com/LeoBKChen/FilterSearchPicker.git
```

### 2. 開啟 Xcode 專案

在終端機中執行以下指令，或直接在 Finder 中開啟 `FilterTextFieldPicker.xcodeproj` 檔案。

```bash
open FilterSearchPicker/FilterTextFieldPicker.xcodeproj
```

### 3. 運行專案

選擇目標模擬器或實體裝置，點擊「運行」按鈕以啟動應用程式。

## 示例

以下是 FilterSearchPicker 的運行示例：

https://github.com/LeoBKChen/FilterSearchPicker/assets/23012132/9447f2dd-4d80-45b0-bcf2-50d7689be950

## 貢獻

歡迎對此專案提出問題或拉取請求。

## 授權

此專案採用 MIT 許可證。

---

# 代碼詳解

以下是專案中關鍵代碼片段的詳細說明，旨在幫助即使對代碼庫不熟悉的使用者也能理解其功能與運作方式。

## 1. 建立資料模型

首先，定義資料模型以表示清單中的每個項目。

```swift
struct Item: Hashable {
    let id: UUID
    let name: String
}
```

## 2. 設置資料來源與快照

```swift
var items: [Item] = [...]
var filteredItems: [Item] = []

var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
snapshot.appendSections([.main])
snapshot.appendItems(filteredItems, toSection: .main)
dataSource.apply(snapshot, animatingDifferences: true)
```

## 3. 配置 Combine 以監聽搜尋輸入

```swift
let searchPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
    .compactMap { ($0.object as? UITextField)?.text }
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .removeDuplicates()

searchPublisher
    .sink { [weak self] searchText in
        self?.filteredItems = self?.items.filter { $0.name.contains(searchText) } ?? []
        self?.updateSnapshot()
    }
    .store(in: &cancellables)
```

## 4. 更新快照以刷新 UI

```swift
func updateSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.main])
    snapshot.appendItems(filteredItems, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
}
```

---

透過上述關鍵代碼片段的講解，希望能幫助您更好地理解 FilterSearchPicker 的運作方式。如有任何疑問，歡迎提出！





