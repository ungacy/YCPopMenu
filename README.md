# YCPopMenu

[![CI Status](http://img.shields.io/travis/ungacy/YCPopMenu.svg?style=flat)](https://travis-ci.org/ungacy/YCPopMenu)
[![Version](https://img.shields.io/cocoapods/v/YCPopMenu.svg?style=flat)](http://cocoapods.org/pods/YCPopMenu)
[![License](https://img.shields.io/cocoapods/l/YCPopMenu.svg?style=flat)](http://cocoapods.org/pods/YCPopMenu)
[![Platform](https://img.shields.io/cocoapods/p/YCPopMenu.svg?style=flat)](http://cocoapods.org/pods/YCPopMenu)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![](https://raw.githubusercontent.com/ungacy/YCPopMenu/master/Example/screen_record.gif)

## Usage

```swift
let data = 1...5
let dataArray = data.map { (title) -> YCPopMenuDemoItem in
    var item = YCPopMenuDemoItem()
    item.menuHeight = 40
    item.title = "\(title)"
    item.id = title
    item.available = title % 3 == 0
    return item
}
let pop = YCPopMenu(dataArray: dataArray, cellClass: YCPopMenuDemoCell.self) { _, data in
    print(data)
}
pop.preferences.basic.menuSize = CGSize(width: 100, height: 30)
pop.preferences.basic.arrowSize = CGSize(width: 10, height: 5)
pop.preferences.basic.coverEdgeInsets = UIEdgeInsetsMake(40, 0, 0, 0)
pop.showFromView(view: sender)
```

## Installation

YCPopMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YCPopMenu'
```

## Author

ungacy, ungacy@126.com

## License

YCPopMenu is available under the MIT license. See the LICENSE file for more info.
