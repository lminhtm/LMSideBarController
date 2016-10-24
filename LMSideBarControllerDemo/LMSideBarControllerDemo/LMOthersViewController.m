//
//  LMOthersViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/23/16.
//  Copyright © 2016 LMinh. All rights reserved.
//

#import "LMOthersViewController.h"
#import "UIViewController+LMSideBarController.h"

@implementation LMOthersViewController

- (IBAction)leftMenuButtonTapped:(id)sender
{
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionLeft];
}

- (IBAction)rightMenuButtonTapped:(id)sender
{
    [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
}

@end
