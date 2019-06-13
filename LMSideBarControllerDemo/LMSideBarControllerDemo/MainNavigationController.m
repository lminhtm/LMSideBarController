//
//  MainNavigationController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "MainNavigationController.h"

@implementation MainNavigationController

#pragma mark - PROPERTIES

- (HomeViewController *)homeViewController
{
    if (!_homeViewController) {
        _homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    }
    return _homeViewController;
}

- (ProfileViewController *)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    }
    return _profileViewController;
}

- (SettingsViewController *)settingsViewController
{
    if (!_settingsViewController) {
        _settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    }
    return _settingsViewController;
}

- (AboutViewController *)aboutViewController
{
    if (!_aboutViewController) {
        _aboutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"];
    }
    return _aboutViewController;
}


#pragma mark - SHOW VIEW CONTROLLERS

- (void)showHomeViewController
{
    [self setViewControllers:@[self.homeViewController] animated:YES];
}

- (void)showProfileViewController
{
    [self setViewControllers:@[self.profileViewController] animated:YES];
}

- (void)showSettingsViewController
{
    [self setViewControllers:@[self.settingsViewController] animated:YES];
}

- (void)showAboutViewController
{
    [self setViewControllers:@[self.aboutViewController] animated:YES];
}

@end
