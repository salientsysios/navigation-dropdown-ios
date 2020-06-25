import UIKit

extension NavigationDropdown {
    open class DropdownButton: UIButton {
        open var dropdownViewController: DropdownViewController!
        open var itemSelectionHandler: Item.SelectionHandler?

        // MARK: - Initialization

        public init?(with containerViewController: UIViewController, items: [Item], selectedItem: Item? = nil) {
            super.init(frame: .zero)

            let arrowImage = AssetManager.image(named: "dropdown_arrow")
            setImage(arrowImage, for: .normal)
            configure()

            addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)

            let itemToSelect = selectedItem ?? items.first
            if let item = itemToSelect {
                setTitle(item)
            }

            // Content
            let contentViewController = DefaultContentViewController(items: items, selectedItem: itemToSelect)

            // Dropdown
            guard let dropdownViewController = DropdownViewController(contentViewController: contentViewController, containerViewController: containerViewController)
                else { return nil }

            self.dropdownViewController = dropdownViewController

            contentViewController.itemSelectionHandler = { [weak self] item in
                self?.setTitle(item)
                self?.itemSelectionHandler?(item)
                self?.dropdownViewController.hide()
            }

            contentViewController.dismiss = { [weak self] in
                self?.dropdownViewController.hide()
            }

            dropdownViewController.animationBlock = { [weak self] isShowing in
                self?.imageView?.transform = isShowing ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform.identity
            }
        }

        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override open func layoutSubviews() {
            super.layoutSubviews()

            let imageWidth: CGFloat = 20
            imageEdgeInsets = UIEdgeInsets(top: 0, left: bounds.width - imageWidth, bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
        }

        // MARK: - Action

        @objc func buttonTouched(_ button: UIButton) {
            dropdownViewController.toggle()
        }
    }
}

private extension NavigationDropdown.DropdownButton {
    func setTitle(_ item: NavigationDropdown.Item) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineHeightMultiple = 0.85
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: NavigationDropdown.Config.Text.color,
            .font: NavigationDropdown.Config.Text.font
        ]
        let title = NSAttributedString(string: item.title, attributes: attributes)
        setAttributedTitle(title, for: .normal)

        sizeToFit()
    }

    func configure() {
        tintColor = NavigationDropdown.Config.tintColor

        titleLabel?.numberOfLines = 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7

        imageView?.contentMode = .scaleAspectFit
    }
}

// MARK: - Update Items
public extension NavigationDropdown.DropdownButton {
    func setSelectedItem(_ item: NavigationDropdown.Item) {
        setTitle(item)
        dropdownViewController.setSelectedItem(item)
    }

    func updateItems(_ items: [NavigationDropdown.Item]) {
        dropdownViewController.updateItems(items)
    }
}

// MARK: - Show/Hide
public extension NavigationDropdown.DropdownButton {
    func showDropdown() {
        dropdownViewController.show()
    }

    func hideDropdown() {
        dropdownViewController.hide()
    }

    var isShowingDropdown: Bool {
        return dropdownViewController.isShowing
    }
}
