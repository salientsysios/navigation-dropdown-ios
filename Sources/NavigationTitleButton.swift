import UIKit

open class NavigationTitleButton: UIButton {
    open var dropdownController: NavigationDropdownController!
    open var itemSelectionHandler: NavigationDropdownItemSelectionHandler?

    // MARK: - Initialization

    public init?(with containerViewController: UIViewController, items: [NavigationDropdownItem], selectedItem: NavigationDropdownItem? = nil) {
        super.init(frame: .zero)

        if let item = selectedItem ?? items.first {
            setTitle(item)
        }

        let arrowImage = AssetManager.image(named: "dropdown_arrow")
        setImage(arrowImage, for: .normal)
        configure()

        addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)

        // Content
        let contentController = NavigationDropdownTableViewController(items: items, selectedItem: selectedItem)

        // Dropdown
        guard let dropdownController = NavigationDropdownController(contentController: contentController, containerViewController: containerViewController)
            else { return nil }

        self.dropdownController = dropdownController

        contentController.action = { [weak self, weak dropdownController] item in
            self?.setSelectedItem(item)
            self?.itemSelectionHandler?(item)
            dropdownController?.hide()
        }

        contentController.dismiss = { [weak dropdownController] in
            dropdownController?.hide()
        }

        dropdownController.animationBlock = { [weak self] showing in
            self?.imageView?.transform = showing ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform.identity
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
        dropdownController.toggle()
    }
}

extension NavigationTitleButton {
    func setTitle(_ item: NavigationDropdownItem) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineHeightMultiple = 0.85
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: Config.Text.color,
            .font: Config.Text.font
        ]
        let title = NSAttributedString(string: item.title, attributes: attributes)
        setAttributedTitle(title, for: .normal)
    }

    func configure() {
        tintColor = Config.tintColor

        titleLabel?.numberOfLines = 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7

        imageView?.contentMode = .scaleAspectFit
    }
}

extension NavigationTitleButton {
    open func setSelectedItem(_ item: NavigationDropdownItem) {
        setTitle(item)
        sizeToFit()
        dropdownController.setSelectedItem(item)
    }
}
