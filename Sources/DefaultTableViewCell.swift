import UIKit

extension NavigationDropdown {
    open class DefaultTableViewCell: UITableViewCell {
        // MARK: - Initialization

        public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            configureUI()
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override open func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            let selectedTintColor: UIColor = selected ? Config.Dropdown.DefaultCell.selectedTintColor : Config.Dropdown.DefaultCell.tintColor
            tintColor = selectedTintColor
            imageView?.tintColor = selectedTintColor
            accessoryType = selected ? .checkmark : .none
        }
    }
}

extension NavigationDropdown.DefaultTableViewCell {
    func configure(with item: NavigationDropdown.Item, isSelected: Bool) {
        textLabel?.text = item.title
        imageView?.image = item.icon
        accessoryType = isSelected ? .checkmark : .none
    }

    func configureLabel() {
        guard let textLabel = textLabel else { return }

        textLabel.textColor = NavigationDropdown.Config.Dropdown.DefaultCell.Text.color
        textLabel.highlightedTextColor = NavigationDropdown.Config.Dropdown.DefaultCell.Text.highlightedTextColor
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping

        if let font = NavigationDropdown.Config.Dropdown.DefaultCell.Text.font {
            textLabel.font = font
        }
    }

    func configureUI() {
        backgroundColor = NavigationDropdown.Config.Dropdown.backgroundColor
        tintColor = NavigationDropdown.Config.Dropdown.DefaultCell.tintColor

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .white
        self.selectedBackgroundView = selectedBackgroundView

        configureLabel()
    }
}
