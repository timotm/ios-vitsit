import UIKit
import SnapKit

class HomeViewController: UITableViewController {

    var dataSource: HomeViewDataSource?
    let vmController: JokeViewModelController

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    init(vmController: JokeViewModelController) {
        self.vmController = vmController
        super.init(style: .grouped)
        title = "Aiheet"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewConstraints()
    }

    func showCategory(category: JokeCategory) {
        let detailViewController = DetailViewController(setFavorite: vmController.setFavorite, jokes: category.jokes)
        navigationController?.pushViewController(detailViewController, animated: true)

    }
}

extension HomeViewController: ViewConstructor {
    func setupViews() {
        navigationController?.navigationBar.tintColor = .label
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        dataSource = HomeViewDataSource(tableView: tableView, vmController: vmController, showCategory: showCategory)
        
    }

    func setupViewConstraints() {
    }
}
