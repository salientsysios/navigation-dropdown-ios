import UIKit

public protocol NavigationDropdownItem {
    var id: Int { get }
    var title: String { get }
    var icon: UIImage? { get }
}

public extension NavigationDropdown {
    typealias Item = NavigationDropdownItem
}
