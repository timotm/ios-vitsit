import UIKit

class JokeViewController: UIViewController {
    let textView: UITextView
    let index: Int
    let favorited: Bool

    init(joke: String, index: Int, favorite: Bool) {
        textView = UITextView().then {
            if let bodySerifDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.serif) {
                $0.font = UIFont(descriptor: bodySerifDescriptor, size: 0)
            }
            $0.text = joke
            $0.isEditable = false
        }
        self.index = index
        self.favorited = favorite
        super.init(nibName: nil, bundle: nil)
        setupViews()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JokeViewController: ViewConstructor {
    func setupViews() {
        view.addSubview(textView)
    }

    func setupViewConstraints() {
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.layoutMarginsGuide).labeled("textViewAll")
        }
    }


}
