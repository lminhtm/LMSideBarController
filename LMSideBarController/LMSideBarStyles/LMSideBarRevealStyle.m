//
//  LMSideMenuParallaxStyle.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarRevealStyle.h"
#import "LMSideBarController.h"

#define kDefaultParallaxOffsetFraction      0.35
#define kDefaultClosedScale                 0.1
#define kDefaultClosedAlpha                 0.0
#define kDefaultPushMagnitudePerSecond      200
#define kDefaultElasticity                  0.1

@interface LMSideBarRevealStyle () <UIDynamicAnimatorDelegate>
{
    CGPoint originMenuCenter;
}
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *contentElasticityBehavior;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *boundaryCollisionBehavior;

@property (nonatomic, assign) CGFloat elasticity;
@property (nonatomic, strong) CALayer *shadowLayer;

@end

@implementation LMSideBarRevealStyle

#pragma mark - INIT

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.parallaxOffsetFraction = kDefaultParallaxOffsetFraction;
        self.closedScale = kDefaultClosedScale;
        self.closedAlpha = kDefaultClosedAlpha;
        self.elasticity = kDefaultElasticity;
        self.hasParallaxEffect = NO;
        self.hasScaleEffect = NO;
        self.hasFadeEffect = NO;
        self.hasShadow = NO;
        self.shouldAlignStatusBar = NO;
    }
    return self;
}


#pragma mark - STYLE

- (void)setContentViewController:(UIViewController *)contentViewController
{
    // Add content shadow layer
    if (self.hasShadow) {
        [self addContentViewShadowLayer];
    }
}

- (void)showMenuViewController
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleWillShowMenuViewController)]) {
        [self.delegate sideBarStyleWillShowMenuViewController];
    }
    
    
    // Prepare animating
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    
    // Set up origin, destination menu center
    originMenuCenter = CGPointMake(CGRectGetMidX(menuViewController.view.frame), CGRectGetMidY(menuViewController.view.frame));
    if (direction == LMSideBarControllerDirectionLeft) {
        originMenuCenter = CGPointMake(-self.sideBarController.view.bounds.size.width + menuViewController.view.bounds.size.width/2, menuViewController.view.bounds.size.height/2);
    }
    else {
        originMenuCenter = CGPointMake(self.sideBarController.view.bounds.size.width + menuViewController.view.bounds.size.width/2, menuViewController.view.bounds.size.height/2);
    }
    
    CGFloat menuXDistanceToMove;
    if (direction == LMSideBarControllerDirectionLeft)
    {
        menuXDistanceToMove = contentViewController.view.bounds.size.width;
    }
    else
    {
        menuXDistanceToMove = -contentViewController.view.bounds.size.width;
    }
    
    [self.sideBarController.view bringSubviewToFront:contentViewController.view];
    [menuViewController.view setCenter:CGPointMake(originMenuCenter.x + menuXDistanceToMove, originMenuCenter.y)];
    
    
    // Animate content, menu view controller
    [self addContentViewDynamicsBehaviorsForMenuState:state direction:direction];
    
    
    // Add content shadow layer
    if (self.hasShadow) {
        [self addContentViewShadowLayer];
    }
    
    
    // Status bar
    if (!self.shouldAlignStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    
    // Delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidShowMenuViewController)]) {
            [self.delegate sideBarStyleDidShowMenuViewController];
        }
    });
}

- (void)hideMenuViewController
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
        [self.delegate sideBarStyleWillHideMenuViewController];
    }
    
    
    // Prepare animating
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    
    
    // Animate content, menu view controller
    [self addContentViewDynamicsBehaviorsForMenuState:state direction:direction];
    
    
    // Add content shadow layer
    if (self.hasShadow) {
        [self addContentViewShadowLayer];
    }
    
    
    // Status bar
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    });
    
    
    // End animating
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.animationDuration + 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menuViewController.view setCenter:CGPointMake(originMenuCenter.x, originMenuCenter.y)];
        [self removeContentViewShadowLayer];
        [self removeAllContentViewDynamicsBehaviors];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
            [self.delegate sideBarStyleDidHideMenuViewController];
        }
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


#pragma mark - SHADOW LAYERS

- (void)addContentViewShadowLayer
{
    [self removeContentViewShadowLayer];
    
    self.shadowLayer = [self.sideBarController.contentViewController.view layer];
    self.shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:self.sideBarController.contentViewController.view.bounds] CGPath];
    self.shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowLayer.shadowOpacity = 1.0;
    self.shadowLayer.shadowRadius = 10;
}

- (void)removeContentViewShadowLayer
{
    self.shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectZero] CGPath];
}


#pragma mark - ANIMATOR

- (void)addContentViewDynamicsBehaviorsForMenuState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    [self removeAllContentViewDynamicsBehaviors];
    
    CGVector gravityDirection = [self gravityDirectionForMenuState:state direction:direction];
    CGFloat pushMagnitude = [self pushMagnitudeForMenuState:state direction:direction];
    CGPoint fromBoundaryPoint = [self fromBoundaryPointForMenuState:state direction:direction];
    CGPoint toBoundaryPoint = [self toBoundaryPointForMenuState:state direction:direction];
    CGFloat contentElasticity = self.elasticity;
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.sideBarController.view];
    self.dynamicAnimator.delegate = self;
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.sideBarController.contentViewController.view]];
    self.boundaryCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.sideBarController.contentViewController.view]];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.sideBarController.contentViewController.view] mode:UIPushBehaviorModeContinuous];
    self.contentElasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.sideBarController.contentViewController.view]];
    __weak typeof(self) weakSelf = self;
    self.gravityBehavior.action = ^{
        [weakSelf handleUpdateDynamicAnimator];
    };
    
    [self.gravityBehavior setGravityDirection:gravityDirection];
    [self.boundaryCollisionBehavior addBoundaryWithIdentifier:@"boundaryCollision" fromPoint:fromBoundaryPoint toPoint:toBoundaryPoint];
    [self.pushBehavior setMagnitude:pushMagnitude];
    [self.contentElasticityBehavior setElasticity:contentElasticity];
    
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.boundaryCollisionBehavior];
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.dynamicAnimator addBehavior:self.contentElasticityBehavior];
}

- (void)removeAllContentViewDynamicsBehaviors
{
    [self.dynamicAnimator removeAllBehaviors];
    self.dynamicAnimator = nil;
    
    self.gravityBehavior = nil;
    self.boundaryCollisionBehavior = nil;
    self.pushBehavior = nil;
    self.contentElasticityBehavior = nil;
}

- (void)handleUpdateDynamicAnimator
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    CGAffineTransform menuViewTransform = menuViewController.view.transform;
    CGFloat alpha = menuViewController.view.alpha;
    CGFloat contentClosedFraction = [self contentViewClosedFractionForDirection:direction];
    
    if (self.shouldAlignStatusBar) {
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9]
                                              encoding:NSASCIIStringEncoding];
        id object = [UIApplication sharedApplication];
        UIView *statusBar;
        if ([object respondsToSelector:NSSelectorFromString(key)]) {
            statusBar = [object valueForKey:key];
        }
        
        statusBar.transform = CGAffineTransformMakeTranslation(contentViewController.view.frame.origin.x, contentViewController.view.frame.origin.y);
    }
    
    if (self.hasParallaxEffect)
    {
        CGFloat translateValue;
        if (direction == LMSideBarControllerDirectionLeft) {
            translateValue = (contentViewController.view.frame.origin.x - self.menuWidth) * self.parallaxOffsetFraction;
        }
        else {
            translateValue = (contentViewController.view.frame.origin.x + self.menuWidth) * self.parallaxOffsetFraction;
        }
        menuViewTransform.tx = CGAffineTransformMakeTranslation(translateValue, 0.0).tx;
    }
    
    if (self.hasScaleEffect)
    {
        CGFloat scale = 1.0 - (contentClosedFraction * self.closedScale);
        
        menuViewTransform.a = CGAffineTransformMakeScale(scale, scale).a;
        menuViewTransform.d = CGAffineTransformMakeScale(scale, scale).d;
    }
    
    if (self.hasFadeEffect)
    {
        alpha = (1.0 - self.closedAlpha) * (1.0  - contentClosedFraction);
    }
    
    menuViewController.view.transform = menuViewTransform;
    menuViewController.view.alpha = alpha;
}


#pragma mark - PROPERTIES FOR ANIMATOR

- (CGVector)gravityDirectionForMenuState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGVector gravityDirection;
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            gravityDirection = CGVectorMake(1, 0);
        }
        else
        {
            gravityDirection = CGVectorMake(-1, 0);
        }
    }
    else
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            gravityDirection = CGVectorMake(-1, 0);
        }
        else
        {
            gravityDirection = CGVectorMake(1, 0);
        }
    }
    
    return gravityDirection;
}

- (CGFloat)pushMagnitudeForMenuState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGFloat finalPushMagnitude = (float)kDefaultPushMagnitudePerSecond/self.animationDuration;
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionRight)
        {
            finalPushMagnitude = -finalPushMagnitude;
        }
    }
    else
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            finalPushMagnitude = -finalPushMagnitude;
        }
    }
    
    return finalPushMagnitude;
}

- (CGPoint)fromBoundaryPointForMenuState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGPoint fromBoundaryPoint;
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            fromBoundaryPoint = CGPointMake(self.sideBarController.view.bounds.size.width + self.menuWidth + 0.5, 0);
        }
        else
        {
            fromBoundaryPoint = CGPointMake(-self.menuWidth + 0.5, 0);
        }
    }
    else
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            fromBoundaryPoint = CGPointMake(-0.5, 0);
        }
        else
        {
            fromBoundaryPoint = CGPointMake(self.sideBarController.view.bounds.size.width + 0.5, 0);
        }
    }
    
    return fromBoundaryPoint;
}

- (CGPoint)toBoundaryPointForMenuState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGPoint toBoundaryPoint;
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            toBoundaryPoint = CGPointMake(self.sideBarController.view.bounds.size.width + self.menuWidth + 0.5, self.sideBarController.contentViewController.view.bounds.size.height);
        }
        else
        {
            toBoundaryPoint = CGPointMake(-self.menuWidth + 0.5, self.sideBarController.contentViewController.view.bounds.size.height);
        }
    }
    else
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            toBoundaryPoint = CGPointMake(-0.5, self.sideBarController.contentViewController.view.bounds.size.height);
        }
        else
        {
            toBoundaryPoint = CGPointMake(self.sideBarController.view.bounds.size.width + 0.5, self.sideBarController.contentViewController.view.bounds.size.height);
        }
    }
    
    return toBoundaryPoint;
}

- (CGFloat)contentViewClosedFractionForDirection:(LMSideBarControllerDirection)direction
{
    CGFloat fraction = 0;
    switch (direction) {
        case LMSideBarControllerDirectionLeft:
            fraction = ((self.menuWidth - self.sideBarController.contentViewController.view.frame.origin.x) / self.menuWidth);
            break;
        case LMSideBarControllerDirectionRight:
            fraction = (1.0 - (fabs(self.sideBarController.contentViewController.view.frame.origin.x) / self.menuWidth));
            break;
        default:
            break;
    }
    // Clip to 0.0 < fraction < 1.0
    fraction = (fraction < 0.0) ? 0.0 : fraction;
    fraction = (fraction > 1.0) ? 1.0 : fraction;
    return fraction;
}

@end
