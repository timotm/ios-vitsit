import UIKit

class SearchViewController: UITableViewController {
    let vmController: JokeViewModelController
    let searchController: UISearchController
    var datasource: SearchViewDataSource?

    init(vmController: JokeViewModelController) {
        self.vmController = vmController
        self.searchController = UISearchController(searchResultsController: nil)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: ViewConstructor {
    func setupViews() {
        datasource = SearchViewDataSource(tableView: tableView, vmController: vmController, showResult: {(index, jokes) in
            let detailViewController = DetailViewController(setFavorite: self.vmController.setFavorite, jokes: jokes, startIndex: index)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        })

        navigationController?.navigationBar.tintColor = .label

        searchController.searchResultsUpdater = datasource

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }

    func setupViewConstraints() {

    }
}
