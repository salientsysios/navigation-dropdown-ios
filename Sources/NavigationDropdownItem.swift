import UIKit

public protocol NavigationDropdownItem {
    var id: Int { get }
    var title: String { get }
    var icon: UIImage? { get }
}
