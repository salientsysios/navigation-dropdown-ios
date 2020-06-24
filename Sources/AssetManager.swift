import UIKit

class AssetManager {
    static func image(named name: String) -> UIImage? {
        let bundle = Bundle(for: AssetManager.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
