# NavigationDropdown

'NavigationDropdown', a lightweight and elegant in Swift

[![Version](https://img.shields.io/cocoapods/v/Dropdowns.svg?style=flat)](http://cocoadocs.org/docsets/navigation-dropdown-ios)
[![License](https://img.shields.io/cocoapods/l/Dropdowns.svg?style=flat)](http://cocoadocs.org/docsets/navigation-dropdown-ios)
[![Platform](https://img.shields.io/cocoapods/p/Dropdowns.svg?style=flat)](http://cocoadocs.org/docsets/navigation-dropdown-ios)
![Swift](https://img.shields.io/badge/%20in-swift%205.0-orange.svg)

<div align="center">
	<img src="Screenshots/dropdown.gif" height="400" />
	<img src="Screenshots/x.png" height="500" />
</div>

## Usage

To create a `NavigationDropdown` from UINavigationBar

### Basic

`NavigationDropdown` works by showing a child `UIViewController` as a dropdown from a `NavigationTitleButton`. The most common use case is to show from a `UINavigationController`, in that sense, you can just create a list of items, and provide to `NavigationTitleButton`.

```swift
let items = ["World", "Sports", "Culture", "Business", "Travel"]
let titleView = NavigationTitleButton(with: self, items: items, selectedItem: nil)
titleView?.itemSelectionHandler = { [weak self] index in
  print("select \(index)")
}

navigationItem.titleView = titleView
```

### Configuration

You can also customize many aspects of `NavigationDropdown` via `Config`

```swift
Config.List.DefaultCell.Text.color = .red
```

## Installation

**NavigationDropdown** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NavigationDropdown'
```

**NavigationDropdown** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "salientsys/navigation-dropdown-ios"
```

**NavigationDropdown** can also be installed manually. Just download and drop `Sources` and `Resources` folders in your project.

## Author

- Salient Systems Corporation, mobile.salientsys@gmai.com

## Credit

- https://github.com/onmyway133/EasyDropdown. Khoa Pham, onmyway133@gmai.com

## Contributing

We would love you to contribute to **NavigationDropdown**, check the [CONTRIBUTING](https://github.com/salientsys/navigation-dropdown-ios/blob/master/CONTRIBUTING.md) file for more info.

## License

**NavigationDropdown** is available under the MIT license. See the [LICENSE](https://github.com/salientsys/navigation-dropdown-ios/blob/master/LICENSE.md) file for more info.
