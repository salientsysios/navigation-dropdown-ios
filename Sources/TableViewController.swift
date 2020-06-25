import UIKit

extension NavigationDropdown {
    public typealias ItemSelectionHandler = ((Item) -> Void)

    open class TableViewController: UIViewController {
        open lazy var tableView: UITableView = self.makeTableView()
        open var itemSelectionHandler: ItemSelectionHandler?
        open var dismiss: (() -> Void)?

        public var items: [Item] {
            didSet {
                if self.isViewLoaded {
                    self.tableView.reloadData()
                }
            }
        }
        private var selectedItem: Item?

        lazy var topView: UIView = self.makeTopView()

        // MARK: - Initialization

        public required init(items: [Item], selectedItem: Item? = nil) {
            self.items = items
            self.selectedItem = selectedItem

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
    }
}

// MARK: - Controls
extension NavigationDropdown.TableViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = NavigationDropdown.Config.Dropdown.rowHeight

        tableView.separatorStyle = .singleLine
        tableView.separatorColor = NavigationDropdown.Config.Dropdown.DefaultCell.separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(NavigationDropdown.DefaultTableViewCell.self, forCellReuseIdentifier: String(describing: NavigationDropdown.DefaultTableViewCell.self))

        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self

        tableView.addGestureRecognizer(gesture)

        return tableView
    }

    func makeTopView() -> UIView {
        let view = UIView()
        view.backgroundColor = NavigationDropdown.Config.Dropdown.backgroundColor

        return view
    }

    // MARK: - Touch

    @objc func viewTapped(_ gesture: UITapGestureRecognizer) {
        dismiss?()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NavigationDropdown.TableViewController: UIGestureRecognizerDelegate {
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UITableView
    }
}

    // MARK: - UITableViewDataSource
extension NavigationDropdown.TableViewController: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: NavigationDropdown.DefaultTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NavigationDropdown.DefaultTableViewCell
        let item = items[indexPath.row]
        let isSelected: Bool = selectedItem?.id == item.id ? true : false

        cell.configure(with: item, isSelected: isSelected)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension NavigationDropdown.TableViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setSelectedItem(items[indexPath.row])
        itemSelectionHandler?(items[indexPath.row])
    }
}

// MARK: - UIScrollViewDelegate
extension NavigationDropdown.TableViewController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.size.width, height: abs(scrollView.contentOffset.y)))
    }
}

extension NavigationDropdown.TableViewController {
    func setSelectedItem(_ item: NavigationDropdown.Item) {
        deselectPreviouslySelectedItem(item)

        selectedItem = item
        selectItem(item)
    }

    func deselectPreviouslySelectedItem(_ newItemToSelect: NavigationDropdown.Item) {
        guard let indexPathForSelectedRow = tableView.indexPathForSelectedRow, items[indexPathForSelectedRow.row].id != newItemToSelect.id else { return }

        tableView.deselectRow(at: indexPathForSelectedRow, animated: false)
    }

    func selectItem(_ item: NavigationDropdown.Item) {
        if let selectedRow = items.firstIndex(where: { $0.id == item.id }) {
            tableView.selectRow(at: IndexPath(row: selectedRow, section: 0), animated: true, scrollPosition: .none)
        }
    }
}
