//
//  UIViewController+LMSideBarController.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "UIViewController+LMSideBarController.h"

@implementation UIViewController (LMSideBarController)

- (LMSideBarController *)sideBarController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[LMSideBarController class]]) {
            return (LMSideBarController *)iter;
        }
        else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        }
        else {
            iter = nil;
        }
    }
    return nil;
}

@end
