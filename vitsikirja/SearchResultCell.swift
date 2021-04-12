import UIKit
import Then

class SearchResultCell: UITableViewCell {
    static let reuseIdentifier = "\(SearchResultCell.self)"
    let excerptLabel = UILabel()
    let rightLabel = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.forward")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultCell: ViewConstructor {
    func setupViews() {
        contentView.addSubview(excerptLabel)
        contentView.addSubview(rightLabel)
    }

    func setupViewConstraints() {
        excerptLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView.layoutMarginsGuide).inset(10).labeled("categoryLabelVertical")
            make.leading.equalTo(contentView.layoutMarginsGuide).labeled("categoryLabelLeading")
        }
        rightLabel.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide).labeled("rightLabelVertical")
            make.width.equalTo(15).labeled("rightLabelWidth")
            make.trailing.equalTo(contentView.layoutMarginsGuide).labeled("rightLabelLeading")
        }
    }
}

