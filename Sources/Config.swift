import UIKit

public struct Config {
    public static var topLineColor: UIColor = .white
    public static var springAnimationDamping: CGFloat = 0.7

    public static var tintColor: UIColor = .white

    public struct Text {
        public static var color: UIColor = .white
        public static var selectedColor: UIColor = .gray
        public static var font: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    }

    public struct List {
        public struct DefaultCell {
            public struct Text {
                public static var color: UIColor = .white
                public static var highlightedTextColor: UIColor = .white
                public static var font: UIFont?
            }

            public static var tintColor: UIColor = .white
            public static var selectedTintColor: UIColor = .lightGray
            public static var highlightedTintColor: UIColor = .lightGray
            public static var separatorColor: UIColor = .white
        }

        public static var backgroundColor: UIColor = UIColor(red: 65 / 255, green: 143 / 255, blue: 152 / 255, alpha: 1)
        public static var rowHeight: CGFloat = 50
    }
}
