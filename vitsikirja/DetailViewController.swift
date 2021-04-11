import UIKit
import SnapKit

class DetailViewController: UIViewController {
    let setFavorite: (Int, Bool) -> ()
    var jokes: [(id: Int, text: String, favorite: Bool)]
    let pageController: UIPageViewController
    var currentIndex: Int = 0

    init(setFavorite: @escaping (Int, Bool)->(), jokes: [(id: Int, text: String, favorite: Bool)]) {
        self.setFavorite = setFavorite
        self.jokes = jokes
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func renderFavoriteButton() {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: jokes[currentIndex].favorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }

    func updateTitle() {
        title = "\(currentIndex+1) / \(jokes.count)"
    }

    @objc func favoriteTapped() {
        jokes[currentIndex].favorite.toggle()
        self.setFavorite(jokes[currentIndex].id, jokes[currentIndex].favorite)
        renderFavoriteButton()
    }
}

extension DetailViewController: ViewConstructor {
    func setupViews() {
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.backgroundColor = .white
        addChild(pageController)
        pageController.didMove(toParent: self)
        view.addSubview(pageController.view)
        let initialVC = JokeViewController(joke: jokes[0].text, index: 0, favorite: jokes[0].favorite)
        pageController.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        renderFavoriteButton()
        updateTitle()

    }

    func setupViewConstraints() {
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

extension DetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? JokeViewController, currentVC.index > 0 else { return nil }

        let i = currentVC.index - 1
        return JokeViewController(joke: jokes[i].text, index: i, favorite: jokes[i].favorite)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? JokeViewController, currentVC.index < jokes.count - 1 else { return nil }

        let i = currentVC.index + 1
        return JokeViewController(joke: jokes[i].text, index: i, favorite: jokes[i].favorite)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return jokes.count
    }

    /*func presentationIndex(for pageViewController: UIPageViewController) -> Int {

     }*/

}

extension DetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? JokeViewController else { return }
        currentIndex = currentVC.index
        updateTitle()
    }
}

