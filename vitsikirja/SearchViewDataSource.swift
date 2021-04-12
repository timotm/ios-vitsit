import UIKit

class SearchViewDataSource: NSObject {
    let vmController: JokeViewModelController
    let showResult: (Int, [(id: Int, text: String, favorite: Bool)])->()
    let tableView: UITableView

    init(tableView: UITableView, vmController: JokeViewModelController, showResult: @escaping (Int, [(id: Int, text: String, favorite: Bool)])->()) {
        self.vmController = vmController
        self.showResult = showResult
        self.tableView = tableView
        super.init()
        vmController.invalidator.append(reloadTableView)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

extension SearchViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vmController.getSearchResults().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else { fatalError("SearchResultCell not created") }

        cell.excerptLabel.attributedText = vmController.getSearchResults()[indexPath.row].excerpt

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension SearchViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showResult(indexPath.row, vmController.getSearchResults().map { ($0.id, $0.fullText, $0.favorite) })
    }
}


extension SearchViewDataSource: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count >= 3 {
            vmController.setSearch(searchText)
        } else {
            vmController.setSearch(nil)
        }

        reloadTableView()
    }
}
