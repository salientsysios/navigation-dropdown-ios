import UIKit

public typealias NavigationDropdownItemSelectionHandler = ((NavigationDropdownItem) -> Void)

open class NavigationDropdownTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    open lazy var tableView: UITableView = self.makeTableView()
    open var action: NavigationDropdownItemSelectionHandler?
    open var dismiss: (() -> Void)?

    public var items: [NavigationDropdownItem] {
        didSet {
            if self.isViewLoaded {
                self.tableView.reloadData()
            }
        }
    }
    var selectedItem: NavigationDropdownItem? {
        didSet {
            if let selectedRow = items.firstIndex(where: { $0.id == selectedItem?.id }) {
                tableView.reloadRows(at: [IndexPath(row: selectedRow, section: 0)], with: .none)
            }
        }
    }
    lazy var topView: UIView = self.makeTopView()

    // MARK: - Initialization

    public required init(items: [NavigationDropdownItem], selectedItem: NavigationDropdownItem? = nil) {
        self.items = items
        self.selectedItem = selectedItem ?? items.first

        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        view.addSubview(topView)
        view.addSubview(tableView)
        tableView.reloadData()
    }

    // MARK: - Layout

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    // MARK: - Controls

    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = NavigationDropdownConfig.List.rowHeight

        tableView.separatorStyle = .singleLine
        tableView.separatorColor = NavigationDropdownConfig.List.DefaultCell.separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(DefaultNavigationDropdownTableViewCell.self, forCellReuseIdentifier: String(describing: DefaultNavigationDropdownTableViewCell.self))

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self

        tableView.addGestureRecognizer(gesture)

        return tableView
    }

    func makeTopView() -> UIView {
        let view = UIView()
        view.backgroundColor = NavigationDropdownConfig.List.backgroundColor

        return view
    }

    // MARK: - Touch

    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        dismiss?()
    }

    // MARK: - GestureDelegate

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
    }

    // MARK: - DataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: DefaultNavigationDropdownTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DefaultNavigationDropdownTableViewCell

        let item = items[indexPath.row]
        //    Config.List.Cell.config(cell, item, (indexPath as NSIndexPath).row, (selectedIndex == (indexPath as NSIndexPath).row))
        let isSelected: Bool = selectedItem?.id == item.id
        cell.configure(with: item, isSelected: isSelected)
        return cell
    }

    // MARK: - Delegate

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathToReloads: [IndexPath] = []
        if let selectedItem = selectedItem, let selectedRow = items.firstIndex(where: { $0.id == selectedItem.id }) {
            indexPathToReloads.append(IndexPath(row: selectedRow, section: 0))
        }

        self.selectedItem = items[indexPath.row]
        indexPathToReloads.append(indexPath)

        tableView.reloadRows(at: indexPathToReloads, with: .automatic)

        action?(items[indexPath.row])
    }

    // MARK: - ScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.size.width, height: abs(scrollView.contentOffset.y)))
    }
}
