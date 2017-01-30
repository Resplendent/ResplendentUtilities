# ResplendentUtilities

[![CI Status](http://img.shields.io/travis/BenMaer/ResplendentUtilities.svg?style=flat)](https://travis-ci.org/BenMaer/ResplendentUtilities)
[![Version](https://img.shields.io/cocoapods/v/ResplendentUtilities.svg?style=flat)](http://cocoadocs.org/docsets/ResplendentUtilities)
[![License](https://img.shields.io/cocoapods/l/ResplendentUtilities.svg?style=flat)](http://cocoadocs.org/docsets/ResplendentUtilities)
[![Platform](https://img.shields.io/cocoapods/p/ResplendentUtilities.svg?style=flat)](http://cocoadocs.org/docsets/ResplendentUtilities)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ResplendentUtilities is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ResplendentUtilities"

## Author

BenMaer, ben@resplendent.co

## License

ResplendentUtilities is available under the MIT license. See the LICENSE file for more info.

## Notes

We currently have the following 7 warnings. None break any functionality, but they should eventually be resolved:

```
➜  ResplendentUtilities git:(development) ✗ pod lib lint

-> ResplendentUtilities (0.5.1)
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:18:33: warning: 'UIRemoteNotificationType' is deprecated: first deprecated in iOS 8.0 - Use UserNotifications Framework's UNAuthorizationOptions for user notifications and registerForRemoteNotifications for receiving remote notifications instead. [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:68:32: note: 'UIRemoteNotificationType' has been explicitly marked deprecated here
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:30:3: warning: 'UIRemoteNotificationType' is deprecated: first deprecated in iOS 8.0 - Use UserNotifications Framework's UNAuthorizationOptions for user notifications and registerForRemoteNotifications for receiving remote notifications instead. [-Wdeprecated-declarations]
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:32:10: warning: 'UIRemoteNotificationTypeBadge' is deprecated: first deprecated in iOS 8.0 - Use UserNotifications Framework's UNAuthorizationOptions for user notifications and registerForRemoteNotifications for receiving remote notifications instead. [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  <scratch space>:2:1: note: expanded from here
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:70:5: note: 'UIRemoteNotificationTypeBadge' has been explicitly marked deprecated here
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:33:4: warning: 'UIRemoteNotificationTypeSound' is deprecated: first deprecated in iOS 8.0 - Use UserNotifications Framework's UNAuthorizationOptions for user notifications and registerForRemoteNotifications for receiving remote notifications instead. [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  <scratch space>:3:1: note: expanded from here
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:71:5: note: 'UIRemoteNotificationTypeSound' has been explicitly marked deprecated here
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:34:4: warning: 'UIRemoteNotificationTypeAlert' is deprecated: first deprecated in iOS 8.0 - Use UserNotifications Framework's UNAuthorizationOptions for user notifications and registerForRemoteNotifications for receiving remote notifications instead. [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  <scratch space>:4:1: note: expanded from here
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:72:5: note: 'UIRemoteNotificationTypeAlert' has been explicitly marked deprecated here
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:73:16: warning: 'enabledRemoteNotificationTypes' is deprecated: first deprecated in iOS 8.0 - Use -[UIApplication isRegisteredForRemoteNotifications] and UserNotifications Framework's -[UNUserNotificationCenter getNotificationSettingsWithCompletionHandler:] to retrieve user-enabled remote notification and user notification settings [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:213:1: note: 'enabledRemoteNotificationTypes' has been explicitly marked deprecated here
- WARN  | xcodebuild:  /Users/benjaminmaer/Documents/Repositories/Resplendent/ResplendentUtilities/Pod/Classes/Category/UIApplication/UIApplication+RUPushNotifications.m:99:10: warning: 'registerForRemoteNotificationTypes:' is deprecated: first deprecated in iOS 8.0 - Use -[UIApplication registerForRemoteNotifications] and UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:] [-Wdeprecated-declarations]
- NOTE  | xcodebuild:  /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator10.2.sdk/System/Library/Frameworks/UIKit.framework/Headers/UIApplication.h:210:1: note: 'registerForRemoteNotificationTypes:' has been explicitly marked deprecated here

[!] ResplendentUtilities did not pass validation, due to 7 warnings (but you can use `--allow-warnings` to ignore them).
[!] The validator for Swift projects uses Swift 3.0 by default, if you are using a different version of swift you can use a `.swift-version` file to set the version for your Pod. For example to use Swift 2.3, run: 
`echo "2.3" > .swift-version`.
You can use the `--no-clean` option to inspect any issue.
```
