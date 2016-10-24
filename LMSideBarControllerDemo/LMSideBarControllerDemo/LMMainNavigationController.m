//
//  LMMainNavigationController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMMainNavigationController.h"

@implementation LMMainNavigationController

- (LMHomeViewController *)homeViewController
{
    if (!_homeViewController) {
        _homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
    }
    return _homeViewController;
}

- (LMOthersViewController *)othersViewController
{
    if (!_othersViewController) {
        _othersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"othersViewController"];
    }
    return _othersViewController;
}

- (void)showHomeViewController
{
    [self setViewControllers:@[self.homeViewController] animated:YES];
}

- (void)showOthersViewController
{
    [self setViewControllers:@[self.othersViewController] animated:YES];
}

@end
