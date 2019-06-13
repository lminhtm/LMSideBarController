//
//  BaseViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 6/13/19.
//  Copyright © 2019 LMinh. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+LMSideBarController.h"

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftMenuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_left_menu"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(leftMenuButtonTapped:)];
    UIBarButtonItem *rightMenuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_right_menu"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(rightMenuButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftMenuItem;
    self.navigationItem.rightBarButtonItem = rightMenuItem;
}

- (void)leftMenuButtonTapped:(id)sender
{
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

- (void)rightMenuButtonTapped:(id)sender
{
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
}


@end
