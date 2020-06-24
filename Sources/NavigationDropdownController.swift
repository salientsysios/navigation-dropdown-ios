import UIKit

public typealias AnimationBlock = (Bool) -> Void

open class NavigationDropdownController: UIViewController {
    open var animationBlock: AnimationBlock?
    open fileprivate(set) var contentController: NavigationDropdownTableViewController?

    weak var containerView: UIView?
    lazy var backgroundView: UIView = self.makeBackgroundView()
    lazy var topLine: CALayer = self.makeTopLine()

    public internal(set) var isShowing: Bool = false
    private var containerViewController: UIViewController?
    private var isAnimating: Bool = false

    // MARK: - Initialization

    public convenience init?(contentController: NavigationDropdownTableViewController, containerViewController: UIViewController) {
        guard let navigationController = containerViewController.navigationController, let containerView = navigationController.tabBarController?.view ?? navigationController.view
            else { return nil }

        self.init(contentController: contentController, containerView: containerView)
        self.containerViewController = containerViewController
    }

    public required init(contentController: NavigationDropdownTableViewController, containerView: UIView) {
        self.containerView = containerView

        super.init(nibName: nil, bundle: nil)

        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        ])

        view.layer.addSublayer(topLine)
        view.clipsToBounds = true

        self.contentController = contentController
        addChild(contentController)
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)

        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrienttationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topLine.frame = CGRect(x: 0, y: 0,
                               width: view.bounds.size.width, height: 1)
        backgroundView.frame = view.bounds
    }

    // MARK: - View

    func makeBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0

        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        view.addGestureRecognizer(gesture)

        return view
    }

    func makeTopLine() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = Config.topLineColor.cgColor

        return layer
    }

    // MARK: - Update
    open func updateItems(_ items: [NavigationDropdownItem]) {
        contentController?.items = items
    }

    open func setSelectedItem(_ item: NavigationDropdownItem) {
        contentController?.selectedItem = item
    }

    // MARK: - Action

    @objc func backgroundViewTapped(_ gesture: UITapGestureRecognizer) {
        hide()
    }

    // MARK: - Showing

    open func toggle() {
        toggle(!isShowing)
    }

    open func show() {
        toggle(true)
    }

    open func hide() {
        toggle(false)
    }

    func toggle(_ isShowing: Bool) {
        guard let containerView = containerView, let contentController = contentController, !isAnimating else { return }

        isAnimating = true

        view.frame = containerViewFrame()
        contentController.view.frame = view.bounds

        if isShowing {
            containerView.addSubview(view)
            backgroundView.alpha = 0
            contentController.view.frame.origin.y -= contentController.view.frame.height
        } else {
            backgroundView.alpha = 0.5
        }

        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: Config.springAnimationDamping,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.animationBlock?(isShowing)

                        if isShowing {
                            self.backgroundView.alpha = 0.5
                            self.topLine.opacity = 1
                            contentController.view.frame.origin.y = 1
                        } else {
                            contentController.view.frame.origin.y -= contentController.view.frame.height
                            self.backgroundView.alpha = 0
                            self.topLine.opacity = 0
                        }
        }, completion: { _ in
            if !isShowing {
                self.view.removeFromSuperview()
            }

            self.isShowing = isShowing
            self.isAnimating = false
        })
    }
}

// MARK: - Device Rotation
extension NavigationDropdownController {
    func containerViewFrame() -> CGRect {
        guard let containerView = containerView else { return .zero }

        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = containerViewController?.navigationController?.navigationBar.frame.height ?? 0
        var offset: CGFloat = 0

        var frame: CGRect = .zero
        if #available(iOS 11.0, *) {
            frame = containerView.safeAreaLayoutGuide.layoutFrame
            offset = navigationBarHeight
        } else {
            frame = containerView.frame
            offset = navigationBarHeight + statusBarHeight
        }

        // NavigationBar height is increased 12 pixels if its titleView is a UISearchBar
        if !isShowing, containerViewController?.navigationItem.titleView is UISearchBar {
            offset += 12
        }

        frame.size.height -= offset
        frame.origin.y += offset

        return frame
    }

    @objc func deviceOrienttationChanged() {
        view.frame = containerViewFrame()
    }
}
