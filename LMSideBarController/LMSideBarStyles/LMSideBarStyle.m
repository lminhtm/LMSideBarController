//
//  LMSideBarStyle.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarStyle.h"

@implementation LMSideBarStyle

- (void)setContentViewController:(UIViewController *)contentViewController
{
    // For subclass
}

- (void)showMenuViewController
{
    // For subclass
}

- (void)hideMenuViewController:(BOOL)animated
{
    // For subclass
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // For subclass
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    // For subclass
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // For subclass
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // For subclass
}

@end
