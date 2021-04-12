import UIKit

class HomeViewDataSource: NSObject {
    let vmController: JokeViewModelController
    let showCategory: (JokeCategory)->()
    let tableView: UITableView

    init(tableView: UITableView, vmController: JokeViewModelController, showCategory: @escaping (JokeCategory)->()) {
        self.vmController = vmController
        self.showCategory = showCategory
        self.tableView = tableView
        super.init()
        vmController.invalidator.append(reloadTableView)
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

extension HomeViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmController.categoryCount[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { fatalError("JokeCell not created") }
        let category = vmController.getCategoryFor(indexPath: indexPath)
        cell.categoryLabel.text = category.category
        cell.categoryIcon.image = category.icon.textToImage()

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return vmController.sections
    }

}

extension HomeViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = vmController.getCategoryFor(indexPath: indexPath)
        if !cat.jokes.isEmpty {
            showCategory(cat)
        }
    }
}



