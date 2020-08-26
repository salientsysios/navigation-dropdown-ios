import UIKit

public protocol NavigationDropdownItem {
    typealias SelectionHandler = ((NavigationDropdownItem) -> Void)

    var id: String { get }
    var title: String { get }
    var icon: UIImage? { get }
}

public extension NavigationDropdown {
    typealias Item = NavigationDropdownItem
}
