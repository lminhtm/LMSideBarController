//
//  LMMainNavigationController.h
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMHomeViewController.h"
#import "LMOthersViewController.h"

@interface LMMainNavigationController : UINavigationController

@property (nonatomic, strong) LMHomeViewController *homeViewController;
@property (nonatomic, strong) LMOthersViewController *othersViewController;

- (void)showHomeViewController;

- (void)showOthersViewController;

@end
