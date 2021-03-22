import UIKit
import Then

class CategoryCell: UITableViewCell {
    static let reuseIdentifier = "\(CategoryCell.self)"
    let categoryIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    let categoryLabel = UILabel().then {
        if let roundedHeadlineDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).withDesign(.rounded) {
            $0.font = UIFont(descriptor: roundedHeadlineDescriptor, size: 0)
        }
    }
    let rightLabel = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.forward")
        $0.tintColor =  .black
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

extension CategoryCell: ViewConstructor {
    func setupViews() {
        contentView.addSubview(categoryIcon)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(rightLabel)
    }
    
    func setupViewConstraints() {
        categoryIcon.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView.layoutMarginsGuide).inset(10).labeled("categoryIconVertical")
            make.leading.equalTo(contentView.layoutMarginsGuide).labeled("categoryIconLeading")
            make.width.equalTo(50).labeled("categoryIconWidth")
        }
        categoryLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentView.layoutMarginsGuide).inset(10).labeled("categoryLabelVertical")
            make.leading.equalTo(categoryIcon.snp.trailing).offset(10).labeled("categoryLabelLeading")
        }
        rightLabel.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide).labeled("rightLabelVertical")
            make.leading.equalTo(categoryLabel.snp.trailing).offset(10).labeled("rightLabelLeading")
        }
    }
}
