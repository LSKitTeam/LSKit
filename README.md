# LSKit

[![CI Status](https://img.shields.io/travis/542634994@qq.com/LSKit.svg?style=flat)](https://travis-ci.org/542634994@qq.com/LSKit)
[![Version](https://img.shields.io/cocoapods/v/LSKit.svg?style=flat)](https://cocoapods.org/pods/LSKit)
[![License](https://img.shields.io/cocoapods/l/LSKit.svg?style=flat)](https://cocoapods.org/pods/LSKit)
[![Platform](https://img.shields.io/cocoapods/p/LSKit.svg?style=flat)](https://cocoapods.org/pods/LSKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Above iOS 8.0

## Installation

LSKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
!pod 'LSKit'
```

##使用方式

###KVO属性监听
	[[self ls_valuesForKeyPath:@"xxxx"] subscribe:^(id value) {
        NSLog(@"change value : %@",value);
    }];

    //其中xxxx为属性字符串

###全局订阅监听

    [[self ls_valuesForGlobalKeyPath:@"xxxx"] subscribe:^(id value) {
        NSLog(@"topic value1 : %@",value);
    }];

    //其中xxxx为全局监听字符串

## Author

@Lyson

@Qingshan

## License

LSKit is available under the MIT license. See the LICENSE file for more info.
