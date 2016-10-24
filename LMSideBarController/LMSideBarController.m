//
//  LMSideBarController.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarController.h"

@interface LMSideBarController () <UIGestureRecognizerDelegate, LMSideBarStyleDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftEdgeGestureRecognizer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightEdgeGestureRecognizer;

@end

@implementation LMSideBarController

@synthesize currentState = _currentState;
@synthesize currentDirection = _currentDirection;
@synthesize currentStyle = _currentStyle;
@synthesize contentViewController = _contentViewController;
@synthesize menuViewControllers = _menuViewControllers;
@synthesize styles = _styles;

#pragma mark - VIEW LIFECYCLE

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _menuViewControllers = [[NSMutableDictionary alloc] init];
    _styles = [[NSMutableDictionary alloc] init];
    _currentState = LMSideBarControllerStateDidClose;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tap Gesture
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    // Pan Gesture
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.enabled = self.panGestureEnabled;
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    // Left Edge Gesture
    self.leftEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    self.leftEdgeGestureRecognizer.enabled = self.panGestureEnabled;
    self.leftEdgeGestureRecognizer.edges = UIRectEdgeLeft;
    self.leftEdgeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.leftEdgeGestureRecognizer];
    
    // Right Edge Gesture
    self.rightEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgeGesture:)];
    self.rightEdgeGestureRecognizer.enabled = self.panGestureEnabled;
    self.rightEdgeGestureRecognizer.edges = UIRectEdgeRight;
    self.rightEdgeGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.rightEdgeGestureRecognizer];
    
    // Configure UI
    self.view.backgroundColor = [UIColor blackColor];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.contentViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.contentViewController;
}


#pragma mark - GET PROPERTIES

- (UIViewController *)menuViewControllerForDirection:(LMSideBarControllerDirection)direction
{
    return [self.menuViewControllers objectForKey:@(direction)];
}

- (LMSideBarStyle *)styleForDirection:(LMSideBarControllerDirection)direction
{
    return [self.styles objectForKey:@(direction)];
}


#pragma mark - SET PROPERTIES

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (!contentViewController || [_contentViewController isEqual:contentViewController]) {
        return;
    }
    
    // Let current side bar style to handle setting content
    LMSideBarStyle *style = [self styleForDirection:_currentDirection];
    if (style) {
        [style setContentViewController:contentViewController];
    }
    
    // Remove the old one if exist
    if (_contentViewController) {
        [self removeViewController:_contentViewController];
    }
    
    // Add the new one
    _contentViewController = contentViewController;
    [self setupViewController:_contentViewController frame:self.view.bounds];
    
    // Update status bar
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController forDirection:(LMSideBarControllerDirection)direction
{
    if (!menuViewController) {
        return;
    }
    
    // Remove the old one if exist
    UIViewController *lastMenuViewController = [self menuViewControllerForDirection:direction];
    if (lastMenuViewController) {
        [self removeViewController:lastMenuViewController];
    }
    
    // Add the new one
    [self.menuViewControllers setObject:menuViewController forKey:@(direction)];
    if (direction == LMSideBarControllerDirectionLeft) {
        [self setupViewController:menuViewController frame:CGRectMake(-self.view.bounds.size.width,
                                                                      0,
                                                                      self.view.bounds.size.width,
                                                                      self.view.bounds.size.height)];
    }
    else {
        [self setupViewController:menuViewController frame:CGRectMake(self.view.bounds.size.width,
                                                                      0,
                                                                      self.view.bounds.size.width,
                                                                      self.view.bounds.size.height)];
    }
    menuViewController.view.hidden = YES;
}

- (void)setSideBarStyle:(LMSideBarStyle *)style forDirection:(LMSideBarControllerDirection)direction
{
    // Add to styles dict
    [self.styles setObject:style forKey:@(direction)];
    
    // Set style delegate
    style.delegate = self;
    
    // Set side bar controller object
    style.sideBarController = self;
}


#pragma mark - PRIVATE METHODS

- (void)setupViewController:(UIViewController *)viewController frame:(CGRect)frame
{
    if (viewController) {
        [self addChildViewController:viewController];
        viewController.view.frame = frame;
        if ([viewController isEqual:_contentViewController]) {
            [self.view insertSubview:viewController.view atIndex:0];
        }
        else {
            [self.view addSubview:viewController.view];
        }
        [viewController didMoveToParentViewController:self];
    }
}

- (void)removeViewController:(UIViewController *)viewController
{
    if (viewController) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}


#pragma mark - SHOW/HIDE METHODS

- (void)showMenuViewControllerInDirection:(LMSideBarControllerDirection)direction
{
    if (_currentState == LMSideBarControllerStateDidClose)
    {
        LMSideBarStyle *style = [self styleForDirection:direction];
        UIViewController *menuViewController = [self menuViewControllerForDirection:direction];
        
        if (style && menuViewController)
        {
            // Update current
            _currentDirection = direction;
            _currentStyle = style;
            
            // Let current side bar style to handle showing menu
            [_currentStyle showMenuViewController];
        }
    }
}

- (void)hideMenuViewController:(BOOL)animated
{
    if (_currentState == LMSideBarControllerStateDidOpen)
    {
        // Let current side bar style to handle hiding menu
        UIViewController *menuViewController = [self menuViewControllerForDirection:_currentDirection];
        if (_currentStyle && menuViewController)
        {
            [_currentStyle hideMenuViewController:animated];
        }
    }
}


#pragma mark - SIDE BAR STYLE DELEGATE

- (void)sideBarStyleWillShowMenuViewController
{
    // Update current state
    _currentState = LMSideBarControllerStateWillOpen;
    
    // Disable content view and menu view
    self.contentViewController.view.userInteractionEnabled = NO;
    UIViewController *menuViewController = [self menuViewControllerForDirection:_currentDirection];
    menuViewController.view.userInteractionEnabled = NO;
    menuViewController.view.hidden = NO;
    
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarController:willShowMenuViewController:)]) {
        [self.delegate sideBarController:self willShowMenuViewController:menuViewController];
    }
}

- (void)sideBarStyleDidShowMenuViewController
{
    // Update current state
    _currentState = LMSideBarControllerStateDidOpen;
    
    // Enabled menu view
    UIViewController *menuViewController = [self menuViewControllerForDirection:_currentDirection];
    menuViewController.view.userInteractionEnabled = YES;
    
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarController:didShowMenuViewController:)]) {
        [self.delegate sideBarController:self didShowMenuViewController:menuViewController];
    }
}

- (void)sideBarStyleWillHideMenuViewController
{
    // Update current state
    _currentState = LMSideBarControllerStateWillClose;
    
    // Disable menu view
    UIViewController *menuViewController = [self menuViewControllerForDirection:_currentDirection];
    menuViewController.view.userInteractionEnabled = NO;
    
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarController:willHideMenuViewController:)]) {
        [self.delegate sideBarController:self willHideMenuViewController:menuViewController];
    }
}

- (void)sideBarStyleDidHideMenuViewController
{
    // Update current state
    _currentState = LMSideBarControllerStateDidClose;
    _currentStyle = nil;
    
    // Enable content view and disable menu view
    self.contentViewController.view.userInteractionEnabled = YES;
    UIViewController *menuViewController = [self menuViewControllerForDirection:_currentDirection];
    menuViewController.view.userInteractionEnabled = NO;
    menuViewController.view.hidden = YES;
    
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarController:didHideMenuViewController:)]) {
        [self.delegate sideBarController:self didHideMenuViewController:menuViewController];
    }
}


#pragma mark - GESTURE RECOGNIZER

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.panGestureRecognizer])
    {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        BOOL horizontalPan = fabs(velocity.x) > fabs(velocity.y);
        
        if (_currentState != LMSideBarControllerStateDidOpen || !_currentStyle || !horizontalPan) {
            return NO;
        }
        
        if (_currentDirection == LMSideBarControllerDirectionLeft && velocity.x > 0) {
            return NO;
        }
        else if (_currentDirection == LMSideBarControllerDirectionRight && velocity.x < 0) {
            return NO;
        }
        
        return YES;
    }
    else if ([gestureRecognizer isEqual:self.tapGestureRecognizer])
    {
        if (_currentState != LMSideBarControllerStateDidOpen || !_currentStyle) {
            return NO;
        }
        return YES;
    }
    else if ([gestureRecognizer isEqual:self.leftEdgeGestureRecognizer] || [gestureRecognizer isEqual:self.rightEdgeGestureRecognizer])
    {
        if (_currentState != LMSideBarControllerStateDidClose) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    // Let current side bar style to handle tap gesture
    if (_currentStyle) {
        [_currentStyle handleTapGesture:gestureRecognizer];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Let current side bar style to handle pan gesture
    if (_currentStyle) {
        [_currentStyle handlePanGesture:gestureRecognizer];
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
}

- (void)handleRightEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    // Update current direction and style
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (_currentState == LMSideBarControllerStateDidClose)
        {
            _currentDirection = LMSideBarControllerDirectionRight;
            _currentStyle = [self styleForDirection:_currentDirection];
        }
    }
    
    // Let current side bar style to handle pan gesture
    if (_currentStyle) {
        [_currentStyle handlePanGesture:gestureRecognizer];
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    // Update current direction and style
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (_currentState == LMSideBarControllerStateDidClose)
        {
            _currentDirection = LMSideBarControllerDirectionLeft;
            _currentStyle = [self styleForDirection:_currentDirection];
        }
    }
    
    // Let current side bar style to handle pan gesture
    if (_currentStyle) {
        [_currentStyle handlePanGesture:gestureRecognizer];
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
}


#pragma mark - ROTATION HANDLER

- (BOOL)shouldAutorotate
{
    if (self.currentState == LMSideBarControllerStateDidOpen || self.currentState == LMSideBarControllerStateDidClose) {
        return self.contentViewController.shouldAutorotate;
    }
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Update menu view frame
    UIViewController *leftMenuViewController = [self menuViewControllerForDirection:LMSideBarControllerDirectionLeft];
    if (leftMenuViewController) {
        leftMenuViewController.view.frame = CGRectMake(-self.view.bounds.size.width,
                                                       0,
                                                       self.view.bounds.size.width,
                                                       self.view.bounds.size.height);
    }
    
    UIViewController *rightMenuViewController = [self menuViewControllerForDirection:LMSideBarControllerDirectionRight];
    if (rightMenuViewController) {
        rightMenuViewController.view.frame = CGRectMake(self.view.bounds.size.width,
                                                        0,
                                                        self.view.bounds.size.width,
                                                        self.view.bounds.size.height);
    }
    
    // Let current side bar style to handle rotation
    if (_currentStyle) {
        [_currentStyle willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    // Let current side bar style to handle rotation
    if (_currentStyle) {
        [_currentStyle didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

@end
