//
//  LMSideBarStyle.h
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LMSideBarController;

/**
 The side bar style protocol.
 */
@protocol LMSideBarStyleDelegate <NSObject, UICollectionViewDelegateFlowLayout>

- (void)sideBarStyleWillShowMenuViewController;
- (void)sideBarStyleDidShowMenuViewController;
- (void)sideBarStyleWillHideMenuViewController;
- (void)sideBarStyleDidHideMenuViewController;

@end

/**
 Wrapper side bar style class
 */
@interface LMSideBarStyle : NSObject

/**
 The side menu width.
 */
@property (nonatomic, assign) CGFloat menuWidth;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 The side bar style delegate.
 */
@property (weak, nonatomic) id<LMSideBarStyleDelegate> delegate;

/**
 The side bar controller object.
 */
@property (nonatomic, strong) LMSideBarController *sideBarController;

/**
 Setter for content view controller.

 @param contentViewController The content view controller
 */
- (void)setContentViewController:(UIViewController *)contentViewController;

/**
 Show menu view controller with current direction.
 */
- (void)showMenuViewController;

/**
 Hide menu view controller with current direction.
 */
- (void)hideMenuViewController:(BOOL)animated;

/**
 Handle tap gesture

 @param tapGestureRecognizer The tap gesture recognizer
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 Handle pan gesture

 @param panGestureRecognizer The pan gesture recognizer
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

/**
 Handle rotation
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

/**
 Handle rotation
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

@end
