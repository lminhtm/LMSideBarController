//
//  LMSideMenuRevealStyle.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarRevealStyle1.h"
#import "LMSideBarController.h"

@implementation LMSideBarRevealStyle1

- (id)init
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)showMenuViewController
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleWillShowMenuViewController)]) {
        [self.delegate sideBarStyleWillShowMenuViewController];
    }
    
    
    // Prepare animating
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    [self.self.sideBarController.view bringSubviewToFront:contentViewController.view];
    
    CGFloat contentDistanceToMove, bounceDistance, menuDistanceToMove;
    if (direction == LMSideBarControllerDirectionRight)
    {
        contentDistanceToMove = -self.menuWidth;
        menuDistanceToMove = -self.sideBarController.view.bounds.size.width;
        bounceDistance = -20;
    }
    else
    {
        contentDistanceToMove = self.menuWidth;
        menuDistanceToMove = self.sideBarController.view.bounds.size.width;
        bounceDistance = 20;
    }
    
    
    // Animate menu view controller
    [menuViewController.view setCenter:CGPointMake(menuViewController.view.center.x + menuDistanceToMove, menuViewController.view.center.y)];
    
    
    // Animate content view controller
    CAKeyframeAnimation *contentBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    contentBounceAnim.duration = self.animationDuration;
    contentBounceAnim.delegate = self;
    contentBounceAnim.removedOnCompletion = NO;
    contentBounceAnim.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCGPoint:contentViewController.view.layer.position]];
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(contentViewController.view.layer.position.x + contentDistanceToMove + bounceDistance,
                                                            contentViewController.view.layer.position.y)]];
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(contentViewController.view.layer.position.x + contentDistanceToMove,
                                                            contentViewController.view.layer.position.y)]];
    contentBounceAnim.values = values;
    
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    contentBounceAnim.keyTimes = keyTimes;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    contentBounceAnim.timingFunctions = timingFunctions;
    
    [contentViewController.view.layer addAnimation:contentBounceAnim forKey:nil];
    [contentViewController.view.layer setValue:[contentBounceAnim.values lastObject] forKeyPath:@"position"];
    
    
    // Delegate
    [UIView animateWithDuration:self.animationDuration animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidShowMenuViewController)]) {
            [self.delegate sideBarStyleDidShowMenuViewController];
        }
    }];
}

- (void)hideMenuViewController
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
        [self.delegate sideBarStyleWillHideMenuViewController];
    }
    
    
    // Prepare animating
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    
    CGFloat contentDistanceToMove, bounceDistance, menuDistanceToMove;
    if (direction == LMSideBarControllerDirectionRight)
    {
        contentDistanceToMove = self.menuWidth;
        menuDistanceToMove = self.sideBarController.view.bounds.size.width;
        bounceDistance = 20;
    }
    else
    {
        contentDistanceToMove = -self.menuWidth;
        menuDistanceToMove = -self.sideBarController.view.bounds.size.width;
        bounceDistance = -20;
    }
    
    
    // Animate menu view controller
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menuViewController.view setCenter:CGPointMake(menuViewController.view.center.x + menuDistanceToMove, menuViewController.view.center.y)];
    });
    
    
    // Animate content view controller
    CAKeyframeAnimation *contentBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    contentBounceAnim.duration = self.animationDuration;
    contentBounceAnim.delegate = self;
    contentBounceAnim.removedOnCompletion = NO;
    contentBounceAnim.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCGPoint:contentViewController.view.layer.position]];
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(contentViewController.view.layer.position.x - bounceDistance,
                                                            contentViewController.view.layer.position.y)]];
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(contentViewController.view.layer.position.x + contentDistanceToMove + bounceDistance,
                                                            contentViewController.view.layer.position.y)]];
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(contentViewController.view.layer.position.x + contentDistanceToMove,
                                                            contentViewController.view.layer.position.y)]];
    contentBounceAnim.values = values;
    
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.2]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.8]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    contentBounceAnim.keyTimes = keyTimes;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    contentBounceAnim.timingFunctions = timingFunctions;
    
    [contentViewController.view.layer addAnimation:contentBounceAnim forKey:nil];
    [contentViewController.view.layer setValue:[contentBounceAnim.values lastObject] forKeyPath:@"position"];
    
    
    // Delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
            [self.delegate sideBarStyleDidHideMenuViewController];
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    });
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint touchLocation = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    
    if (CGRectContainsPoint(contentViewController.view.frame, touchLocation))
    {
        [self hideMenuViewController];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
}

@end
