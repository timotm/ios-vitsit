import UIKit

class RootViewController: UITabBarController {

    let vmController: JokeViewModelController

    init(vmController: JokeViewModelController) {
        self.vmController = vmController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("foo")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeViewController = HomeViewController(vmController: vmController)
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)

        let searchViewController = SearchViewController(vmController: vmController)
        searchViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let categoriesViewController = CategoriesViewController(vmController: vmController)
        categoriesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "slider.horizontal.3"), tag: 3)


        viewControllers = [UINavigationController(rootViewController: homeViewController),
                           UINavigationController(rootViewController: searchViewController),
                           UINavigationController(rootViewController: categoriesViewController)]
    }

}
