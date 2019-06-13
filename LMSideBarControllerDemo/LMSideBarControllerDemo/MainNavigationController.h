//
//  MainNavigationController.h
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "AboutViewController.h"

@interface MainNavigationController : UINavigationController

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, strong) SettingsViewController *settingsViewController;
@property (nonatomic, strong) AboutViewController *aboutViewController;

- (void)showHomeViewController;

- (void)showProfileViewController;

- (void)showSettingsViewController;

- (void)showAboutViewController;

@end
