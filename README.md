# LMSideBarController
LMSideBarController is a simple side bar controller inspired by Tappy and Simon Hoang.

<img src="https://raw.github.com/lminhtm/LMSideBarController/master/Screenshots/screenshot1.png"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://raw.github.com/lminhtm/LMSideBarController/master/Screenshots/screenshot4.gif"/>

## Features
* Side bar controller with blur+transform3D effect.
* Support both left and right bar controller with different side bar styles.
* Pan Gesture available.
* Expandable structure.

## Requirements
* Xcode 8 or higher
* iOS 8.0 or higher
* ARC

## Installation
#### From CocoaPods
```ruby
pod 'LMSideBarController'
```
#### Manually
* Drag the `LMSideBarController` folder into your project.
* Add `#include "LMSideBarController.h"` to the top of classes that will use it.

## Usage
You can subclass LMSideBarController and setup it in awakeFromNib method.
```ObjC
// Init side bar styles
LMSideBarDepthStyle *sideBarDepthStyle = [LMSideBarDepthStyle new];
sideBarDepthStyle.menuWidth = 220;
    
// Init view controllers
LMLeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
LMRightMenuViewController *rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
LMMainNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    
// Setup side bar controller
[self setPanGestureEnabled:YES];
[self setDelegate:self];
[self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
[self setMenuViewController:rightMenuViewController forDirection:LMSideBarControllerDirectionRight];
[self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
[self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionRight];
[self setContentViewController:navigationController];
```
You can present it manually:
```ObjC
[self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
```
or hide it:
```ObjC
[self.sideBarController hideMenuViewController:YES];
```
See sample Xcode project in `/LMSideBarControllerDemo`

## License
LMSideBarController is licensed under the terms of the MIT License.

## Contact
Minh Luong Nguyen
* https://github.com/lminhtm
* lminhtm@gmail.com

## Donations
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/lminhtm/5USD)
