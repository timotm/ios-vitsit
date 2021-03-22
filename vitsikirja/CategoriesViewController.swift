import UIKit

class CategoriesViewController: UIViewController {
    
    let vmController: JokeViewModelController
    
    init(vmController: JokeViewModelController) {
        self.vmController = vmController
        super.init(nibName: nil, bundle: nil)
        title = "Asetukset"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewConstraints()
    }
}

extension CategoriesViewController: ViewConstructor {
    func setupViews() {
        view.backgroundColor = UIColor.white

        let scrollView = UIScrollView().then {
                        $0.alwaysBounceVertical = true
            $0.contentInsetAdjustmentBehavior = .always
        }
        
        let container = UIView()

        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        stackView.addArrangedSubview(UILabel().then {
            $0.text = "Näytä aiheet"
            $0.font = UIFont.boldSystemFont(ofSize: 24)
        })

        vmController.getEnabledCategories().forEach { (arg) in
            let (category, index, enabled) = arg
            let label = UILabel().then {
                $0.text = category
            }
            let toggle = UISwitch().then {
                $0.isOn = enabled
                $0.tag = index
            }
            toggle.addAction(UIAction() { [weak toggle] _ in
                guard let toggle = toggle else { return }
                self.vmController.setCategoryEnablement(index: toggle.tag, enabled: toggle.isOn)
            }, for: .valueChanged)

            stackView.addArrangedSubview(UIStackView(arrangedSubviews: [label, toggle]))
        }
        
        
        container.addSubview(stackView)
        scrollView.addSubview(container)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(20)
        }

    }
    
    func setupViewConstraints() {        
    }
    
}

