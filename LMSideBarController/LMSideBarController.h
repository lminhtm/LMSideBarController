//
//  LMSideBarController.h
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSideBarStyle.h"
#import "UIViewController+LMSideBarController.h"

/**
 The side bar controller direction enums.
 */
typedef NS_ENUM(NSUInteger, LMSideBarControllerDirection) {
    LMSideBarControllerDirectionLeft,
    LMSideBarControllerDirectionRight,
};

/**
 The side bar controller state enums.
 */
typedef NS_ENUM(NSUInteger, LMSideBarControllerState) {
    LMSideBarControllerStateWillOpen,
    LMSideBarControllerStateDidOpen,
    LMSideBarControllerStateWillClose,
    LMSideBarControllerStateDidClose,
};

@protocol LMSideBarControllerDelegate;

/**
 LMSideBarController is a simple side bar controller inspired by Tappy.
 */
@interface LMSideBarController : UIViewController

/**
 The current side bar state.
 */
@property (nonatomic, assign, readonly) LMSideBarControllerState currentState;

/**
 The current side bar direction.
 */
@property (nonatomic, assign, readonly) LMSideBarControllerDirection currentDirection;

/**
 The current side bar style.
 */
@property (nonatomic, strong, readonly) LMSideBarStyle *currentStyle;

/**
 The menu view controller dictionary.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *menuViewControllers;

/**
 The side bar style dictionary.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *styles;

/**
 The content view controller.
 */
@property (nonatomic, strong) UIViewController *contentViewController;

/**
 A boolean indicates whether pan gesture is enabled.
 */
@property (nonatomic, assign) BOOL panGestureEnabled;

/**
 The side bar controller delegate.
 */
@property (nonatomic, weak) id<LMSideBarControllerDelegate> delegate;

/**
 Getter for menu view controller.
 */
- (UIViewController *)menuViewControllerForDirection:(LMSideBarControllerDirection)direction;

/**
 Setup content view controller.
 */
- (void)setContentViewController:(UIViewController *)contentViewController;

/**
 Setup menu view controller for specified direction.
 */
- (void)setMenuViewController:(UIViewController *)menuViewController forDirection:(LMSideBarControllerDirection)direction;

/**
 Setup side bar style for specified direction.
 */
- (void)setSideBarStyle:(LMSideBarStyle *)style forDirection:(LMSideBarControllerDirection)direction;

/**
 Show menu view controller in specified direction.
 */
- (void)showMenuViewControllerInDirection:(LMSideBarControllerDirection)direction;

/**
 Hide menu view controller.
 */
- (void)hideMenuViewController:(BOOL)animated;

@end

/**
 The side bar controller delegate
 */
@protocol LMSideBarControllerDelegate <NSObject>

@optional
- (void)sideBarController:(LMSideBarController *)sideBarController willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideBarController:(LMSideBarController *)sideBarController didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideBarController:(LMSideBarController *)sideBarController willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideBarController:(LMSideBarController *)sideBarController didHideMenuViewController:(UIViewController *)menuViewController;

@end
