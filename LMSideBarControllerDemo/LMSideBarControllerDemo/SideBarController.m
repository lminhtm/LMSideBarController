//
//  ViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "SideBarController.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "MainNavigationController.h"
#import "LMSideBarDepthStyle.h"

@implementation SideBarController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Init side bar styles
    LMSideBarDepthStyle *sideBarDepthStyle = [LMSideBarDepthStyle new];
    sideBarDepthStyle.menuWidth = 220;
    
    // Init view controllers
    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    RightMenuViewController *rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    MainNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    
    // Setup side bar controller
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    [self setMenuViewController:leftMenuViewController forDirection:LMSideBarControllerDirectionLeft];
    [self setMenuViewController:rightMenuViewController forDirection:LMSideBarControllerDirectionRight];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionLeft];
    [self setSideBarStyle:sideBarDepthStyle forDirection:LMSideBarControllerDirectionRight];
    [self setContentViewController:navigationController];
}


#pragma mark - SIDE BAR DELEGATE

- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController
{
    
}

@end
