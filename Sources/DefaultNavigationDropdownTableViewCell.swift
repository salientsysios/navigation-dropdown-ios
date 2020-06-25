import UIKit

open class DefaultNavigationDropdownTableViewCell: UITableViewCell {
    // MARK: - Initialization

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controls
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let selectedTintColor: UIColor = selected ? NavigationDropdownConfig.List.DefaultCell.selectedTintColor : NavigationDropdownConfig.List.DefaultCell.tintColor
        tintColor = selectedTintColor
        imageView?.tintColor = selectedTintColor
    }

    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        let highlightedTintColor: UIColor = highlighted ? NavigationDropdownConfig.List.DefaultCell.highlightedTintColor : NavigationDropdownConfig.List.DefaultCell.tintColor
        tintColor = highlightedTintColor
        imageView?.tintColor = highlightedTintColor
    }
}

extension DefaultNavigationDropdownTableViewCell {
    func configure(with item: NavigationDropdownItem, isSelected: Bool) {
        textLabel?.text = item.title
        imageView?.image = item.icon
        accessoryType = isSelected ? .checkmark : .none
    }

    func configureLabel() {
        textLabel?.textColor = NavigationDropdownConfig.List.DefaultCell.Text.color
        textLabel?.highlightedTextColor = NavigationDropdownConfig.List.DefaultCell.Text.highlightedTextColor
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping

        if let font = NavigationDropdownConfig.List.DefaultCell.Text.font {
            textLabel?.font = font
        }
    }

    func configureUI() {
        backgroundColor = NavigationDropdownConfig.List.backgroundColor
        tintColor = NavigationDropdownConfig.List.DefaultCell.tintColor

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .white
        self.selectedBackgroundView = selectedBackgroundView

        configureLabel()
    }
}
