import NavigationDropdown

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    var titleView: NavigationDropdown.DropdownButton!

    let color = UIColor(red: 22 / 255, green: 160 / 255, blue: 33 / 255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        button.layer.cornerRadius = 4

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = color

        setupNavigationItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        titleView.setNeedsLayout()
        titleView.layoutIfNeeded()
    }

    // MARK: - Navigation

    func setupNavigationItem() {

        let texts = [
            "World",
            "Sports",
            "Culture",
            "Business",
            "Very Long long long long text should be displayed in two lines",
            "World",
            "Sports",
            "Culture",
            "Business",
            "Travel",
            "Education",
            "Another long long long long long text two lines",
            "World",
            "Sports",
            "Culture",
            "Business",
            "Travel",
            "Education",
            "Entertainment",
            "World",
            "Sports",
            "Culture",
            "Business",
            "Travel",
            "Education",
            "Entertainment"
        ]
        let items: [MyNavigationMenuItem] = texts.enumerated().map { (index, element) in
            return MyNavigationMenuItem(id: index, title: element, icon: UIImage(named: "firewatch"))
        }
        titleView = NavigationDropdown.DropdownButton(with: self, items: items )
        titleView?.itemSelectionHandler = { [weak self] item in
            self?.button.setTitle(item.title, for: .normal)
            self?.button.layoutIfNeeded()
        }

        navigationItem.titleView = titleView
    }

    @IBAction func btnTapped(_ sender: Any) {}
}

struct MyNavigationMenuItem: NavigationDropdownItem {
    let id: Int
    let title: String
    let icon: UIImage?

    public init(id: Int, title: String, icon: UIImage? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
    }
}
