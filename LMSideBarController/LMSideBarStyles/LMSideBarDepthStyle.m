//
//  LMSideBarDepthStyle.m
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarDepthStyle.h"
#import "LMSideBarController.h"
#import "UIImage+LMExtension.h"

#define frx(a)                              (a.frame.origin.x)
#define fry(a)                              (a.frame.origin.y)
#define midx(a)                             (CGRectGetMidX(a.frame))
#define midy(a)                             (CGRectGetMidY(a.frame))
#define W(a)                                (a.frame.size.width)
#define H(a)                                (a.frame.size.height)

#define kDefaultAnimationDuration           0.6
#define kDefaultDepthStyleClosedScale       0.8
#define kDefaultBlurRadius                  5
#define kDefaultBlackMaskAlpha              0.4
#define kDefaultAnimationBounceScale        0.05

@interface LMSideBarDepthStyle ()
{
    CGPoint originMenuCenter;
    CGPoint desMenuCenter;
    CGPoint originContentCenter;
    CGFloat animationBounceSize;
}
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *contentWrapperView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIView *blackView;

@end

@implementation LMSideBarDepthStyle

@synthesize menuWidth = _menuWidth;

#pragma mark - INIT

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.menuWidth = [UIScreen mainScreen].bounds.size.width * 2/3;
        self.animationDuration = kDefaultAnimationDuration;
        self.closedScale = kDefaultDepthStyleClosedScale;
        self.shouldBlurContentView = YES;
        self.blurRadius = kDefaultBlurRadius;
        self.blackMaskAlpha = kDefaultBlackMaskAlpha;
    }
    return self;
}


#pragma mark - PROPERTIES

- (void)setMenuWidth:(CGFloat)menuWidth
{
    _menuWidth = MIN(MAX(menuWidth, 50), [[UIScreen mainScreen] bounds].size.width);
}

- (void)setClosedScale:(CGFloat)closedScale
{
    _closedScale = MIN(MAX(closedScale, 0.5), 1);
}

- (void)setBlackMaskAlpha:(CGFloat)blackMaskAlpha
{
    _blackMaskAlpha = MIN(MAX(blackMaskAlpha, 0), 0.9);
}


#pragma mark - STYLE OVERRIDE

- (void)setContentViewController:(UIViewController *)contentViewController
{
    self.contentView = contentViewController.view;
}

- (void)prepareForShowingMenuViewController
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    UIViewController *menuViewController = [self.sideBarController menuViewControllerForDirection:direction];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    
    // Prepare showing
    self.menuView = menuViewController.view;
    self.contentView = contentViewController.view;
    [self.contentWrapperView removeFromSuperview];
    [self.sideBarController.view bringSubviewToFront:self.menuView];
    
    // Prepare content view controller captured image
    CGSize contentSize = [self.contentView bounds].size;
    CGFloat scale = (3 - 2 * self.closedScale);
    CGSize capturedSize = CGSizeMake(contentSize.width, contentSize.height * scale);
    UIImage *capturedImage = [UIImage imageFromView:self.contentView withSize:capturedSize];
    UIImage *contentImage = capturedImage;
    if (self.shouldBlurContentView) {
        contentImage = [capturedImage blurredImageWithRadius:self.blurRadius iterations:5 tintColor:[UIColor clearColor]];
    }
    
    // Content Wrapper View
    if (!self.contentWrapperView) {
        self.contentWrapperView = [[UIView alloc] init];
    }
    self.contentWrapperView.frame = self.contentView.bounds;
    self.contentWrapperView.alpha = 1;
    if (!self.contentWrapperView.superview) {
        [self.sideBarController.view insertSubview:self.contentWrapperView belowSubview:self.menuView];
    }
    
    // Content Image View
    if (!self.contentImageView) {
        self.contentImageView = [[UIImageView alloc] init];
        self.contentImageView.backgroundColor = [UIColor blackColor];
        self.contentImageView.contentMode = UIViewContentModeCenter;
    }
    self.contentImageView.image = contentImage;
    self.contentImageView.frame = CGRectMake(-contentSize.width * (1 - self.closedScale),
                                             -contentSize.height * (1 - self.closedScale),
                                             contentSize.width * scale,
                                             contentSize.height * scale);
    if (!self.contentImageView.superview) {
        [self.contentWrapperView addSubview:self.contentImageView];
    }
    
    // Black view
    if (!self.blackView) {
        self.blackView = [[UIView alloc] init];
    }
    self.blackView.frame = self.contentWrapperView.bounds;
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.blackMaskAlpha];
    if (!self.blackView.superview) {
        [self.contentWrapperView addSubview:self.blackView];
    }
    
    // Set up origin, destination center
    animationBounceSize = (W(self.contentView) * (1 - self.closedScale))/2;
    originContentCenter = CGPointMake(midx(self.contentImageView), midy(self.contentImageView));
    if (direction == LMSideBarControllerDirectionLeft) {
        originMenuCenter = CGPointMake(-W(self.menuView)/2, midy(self.menuView));
        desMenuCenter = CGPointMake(originMenuCenter.x + self.menuWidth, midy(self.menuView));
    }
    else {
        originMenuCenter = CGPointMake(W(self.menuView) * 3/2, midy(self.menuView));
        desMenuCenter = CGPointMake(originMenuCenter.x - self.menuWidth, midy(self.menuView));
    }
}

- (void)showMenuViewController
{
    // Start showing
    [self startShowing];
    
    // Prepare for showing menu controller
    [self prepareForShowingMenuViewController];
    
    // Animate menu view controller
    [self addMenuViewAnimation];
    
    // Animate content view controller
    if (self.closedScale < 1) {
        [self addContentViewAnimation];
    }
    
    // Finish showing
    [self finishShowing];
}

- (void)hideMenuViewController:(BOOL)animated
{
    // Start hiding
    [self startHiding];
    
    if (animated)
    {
        // Animate menu view controller
        [self addMenuViewAnimation];
        
        // Animate content view controller
        if (self.closedScale < 1) {
            [self addContentViewAnimation];
        }
    }
    else
    {
        // Menu view controller
        LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
        LMSideBarControllerState state = self.sideBarController.currentState;
        NSNumber *menuPositionX = [[self menuPositionXValuesForState:state direction:direction] lastObject];
        [self.menuView.layer setValue:menuPositionX forKeyPath:@"position.x"];
        
        // Content view controller
        NSValue *transform = [[self contentTransformValuesForState:state direction:direction] lastObject];
        [self.contentImageView.layer setValue:transform forKeyPath:@"transform"];
        
        NSNumber *positionX = [[self contentPositionXValuesForState:state direction:direction] lastObject];
        [self.contentImageView.layer setValue:positionX forKey:@"position.x"];
    }
    
    // Finish hiding
    [self finishHiding:animated];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint touchLocation = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    
    LMSideBarControllerDirection currentMenuDirection = self.sideBarController.currentDirection;
    UIViewController *currentMenuViewController = [self.sideBarController menuViewControllerForDirection:currentMenuDirection];
    UIViewController *contentViewController = self.sideBarController.contentViewController;
    
    if (CGRectContainsPoint(contentViewController.view.frame, touchLocation) &&
        !CGRectContainsPoint(currentMenuViewController.view.frame, touchLocation))
    {
        [self hideMenuViewController:YES];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    
    // Modify the translation
    translation.x = MIN(translation.x, 10);
    translation.x = MAX(translation.x, -10);
    
    // Handle gesture
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (state == LMSideBarControllerStateDidClose)
        {
            // Start showing
            [self startShowing];
            
            // Prepare for showing menu controller
            [self prepareForShowingMenuViewController];
        }
        else if (state == LMSideBarControllerStateDidOpen)
        {
            // Start hiding
            [self startHiding];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        // Animate menu view controller
        [self addMenuViewAnimationWithTranslation:translation velocity:velocity];
        
        // Animate content view controller
        if (self.closedScale < 1) {
            [self addContentViewAnimationWithTranslation:translation velocity:velocity];
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (direction == LMSideBarControllerDirectionLeft)
        {
            if (velocity.x < 0)
            {
                // Start hiding
                [self startHiding];
            }
            else
            {
                // Start showing
                [self startShowing];
            }
        }
        else
        {
            if (velocity.x < 0)
            {
                // Start showing
                [self startShowing];
            }
            else
            {
                // Start hiding
                [self startHiding];
            }
        }
        
        // Animate menu view controller
        [self addMenuViewAnimation];
        
        // Animate content view controller
        if (self.closedScale < 1) {
            [self addContentViewAnimation];
        }
        
        if (self.sideBarController.currentState == LMSideBarControllerStateWillOpen)
        {
            // Finish showing
            [self finishShowing];
        }
        else if (self.sideBarController.currentState == LMSideBarControllerStateWillClose)
        {
            // Finish hiding
            [self finishHiding:YES];
        }
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    
    // Hide menu if needed
    if (state == LMSideBarControllerStateDidOpen || state == LMSideBarControllerStateDidClose)
    {
        // Set up origin, destination center
        animationBounceSize = (W(self.contentView) * (1 - self.closedScale))/2;
        originContentCenter = CGPointMake(midx(self.contentImageView), midy(self.contentImageView));
        if (direction == LMSideBarControllerDirectionLeft) {
            originMenuCenter = CGPointMake(-W(self.menuView)/2, midy(self.menuView));
            desMenuCenter = CGPointMake(originMenuCenter.x + self.menuWidth, midy(self.menuView));
        }
        else {
            originMenuCenter = CGPointMake(W(self.menuView) * 3/2, midy(self.menuView));
            desMenuCenter = CGPointMake(originMenuCenter.x - self.menuWidth, midy(self.menuView));
        }
        
        // Force hide menu
        [self hideMenuViewController:NO];
    }
}


#pragma mark - SUPPORT

- (void)startShowing
{
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleWillShowMenuViewController)]) {
        [self.delegate sideBarStyleWillShowMenuViewController];
    }
    
    // Content View
    self.contentView.hidden = YES;
}

- (void)finishShowing
{
    // Call delegate
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidShowMenuViewController)]) {
            [self.delegate sideBarStyleDidShowMenuViewController];
        }
    });
}

- (void)startHiding
{
    // Call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleWillHideMenuViewController)]) {
        [self.delegate sideBarStyleWillHideMenuViewController];
    }
    
    // Content View
    self.contentView.hidden = YES;
}

- (void)finishHiding:(BOOL)animated
{
    if (animated)
    {
        // Call delegate
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
                [self.delegate sideBarStyleDidHideMenuViewController];
            }
        });
        
        // Animate hiding and removing content wrapper view
        BOOL isAtDesCenter = self.menuView.layer.presentationLayer.position.x == desMenuCenter.x;
        CGFloat delay = isAtDesCenter ? (self.animationDuration - 0.1) : 0.2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.1 animations:^{
                self.contentWrapperView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.contentWrapperView removeFromSuperview];
            }];
            
            // Content View
            self.contentView.hidden = NO;
        });
    }
    else
    {
        // Call delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(sideBarStyleDidHideMenuViewController)]) {
            [self.delegate sideBarStyleDidHideMenuViewController];
        }
        
        // Remove content wrapper view
        [UIView animateWithDuration:0.1 animations:^{
            self.contentWrapperView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.contentWrapperView removeFromSuperview];
        }];
        
        // Content View
        self.contentView.hidden = NO;
    }
}


#pragma mark - MENU VIEW KEYFRAME ANIMATION

- (void)addMenuViewAnimation
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    positionAnim.duration = self.animationDuration;
    positionAnim.values = [self menuPositionXValuesForState:state direction:direction];
    positionAnim.timingFunctions = [self menuTimingFunctionsForState:state direction:direction];
    positionAnim.keyTimes = [self menuKeyTimesForState:state direction:direction];
    
    [self.menuView.layer addAnimation:positionAnim forKey:nil];
    [self.menuView.layer setValue:[positionAnim.values lastObject] forKeyPath:@"position.x"];
}

- (void)addMenuViewAnimationWithTranslation:(CGPoint)translation velocity:(CGPoint)velocity
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    
    CGFloat positionX = [self menuPositionXForState:state direction:direction translation:translation velocity:velocity];
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    positionAnim.duration = 0;
    positionAnim.values = @[@(positionX)];
    
    [self.menuView.layer addAnimation:positionAnim forKey:nil];
    [self.menuView.layer setValue:[positionAnim.values lastObject] forKeyPath:@"position.x"];
}

- (CGFloat)destinationMenuPositionXForDirection:(LMSideBarControllerDirection)direction velocity:(CGPoint)velocity
{
    if (direction == LMSideBarControllerDirectionLeft) {
        if (velocity.x < 0) {
            return originMenuCenter.x;
        }
        return desMenuCenter.x + animationBounceSize;
    }
    else {
        if (velocity.x < 0) {
            return desMenuCenter.x - animationBounceSize;
        }
        return originMenuCenter.x;
    }
}

- (NSArray *)menuPositionXValuesForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGFloat currentMenuPositionX = self.menuView.layer.position.x;
    
    NSMutableArray *values = [NSMutableArray new];
    [values addObject:@(currentMenuPositionX)];
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionLeft) {
            [values addObject:@(desMenuCenter.x + animationBounceSize)];
        }
        else {
            [values addObject:@(desMenuCenter.x - animationBounceSize)];
        }
        [values addObject:@(desMenuCenter.x)];
    }
    else
    {
        if (self.menuView.layer.presentationLayer.position.x == desMenuCenter.x)
        {
            if (direction == LMSideBarControllerDirectionLeft) {
                [values addObject:@(currentMenuPositionX + animationBounceSize)];
            }
            else {
                [values addObject:@(currentMenuPositionX - animationBounceSize)];
            }
        }
        [values addObject:@(originMenuCenter.x)];
    }
    
    return values;
}

- (CGFloat)menuPositionXForState:(LMSideBarControllerState)state
                       direction:(LMSideBarControllerDirection)direction
                     translation:(CGPoint)translation
                        velocity:(CGPoint)velocity
{
    CGFloat currentMenuPositionX = self.menuView.layer.position.x;
    
    CGFloat menuPositionX = currentMenuPositionX;
    menuPositionX = currentMenuPositionX + translation.x;
    
    if (direction == LMSideBarControllerDirectionLeft) {
        menuPositionX = MIN(menuPositionX, desMenuCenter.x);
        menuPositionX = MAX(menuPositionX, originMenuCenter.x);
    }
    else {
        menuPositionX = MIN(menuPositionX, originMenuCenter.x);
        menuPositionX = MAX(menuPositionX, desMenuCenter.x);
    }
    
    return menuPositionX;
}

- (NSArray *)menuKeyTimesForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    NSMutableArray *keyTimes = [NSMutableArray new];
    [keyTimes addObject:@(0)];
    [keyTimes addObject:@(0.5)];
    [keyTimes addObject:@(1)];
    return keyTimes;
}

- (NSArray *)menuTimingFunctionsForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    NSMutableArray *timingFunctions = [NSMutableArray new];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}


#pragma mark - CONTENT VIEW KEYFRAME ANIMATION

- (void)addContentViewAnimation
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    
    // Transform Animation
    CAKeyframeAnimation *scaleBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleBounceAnim.duration = self.animationDuration;
    scaleBounceAnim.values = [self contentTransformValuesForState:state direction:direction];
    scaleBounceAnim.timingFunctions = [self contentTimingFunctionsForState:state direction:direction];
    scaleBounceAnim.keyTimes = [self contentKeyTimesForState:state direction:direction];
    
    [self.contentImageView.layer addAnimation:scaleBounceAnim forKey:nil];
    [self.contentImageView.layer setValue:[scaleBounceAnim.values lastObject] forKeyPath:@"transform"];
    
    // Position Animation
    CAKeyframeAnimation *positionBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    positionBounceAnim.duration = self.animationDuration;
    positionBounceAnim.values = [self contentPositionXValuesForState:state direction:direction];
    positionBounceAnim.timingFunctions = [self contentTimingFunctionsForState:state direction:direction];
    positionBounceAnim.keyTimes = [self contentKeyTimesForState:state direction:direction];
    
    [self.contentImageView.layer addAnimation:positionBounceAnim forKey:nil];
    [self.contentImageView.layer setValue:[positionBounceAnim.values lastObject] forKeyPath:@"position.x"];
}

- (void)addContentViewAnimationWithTranslation:(CGPoint)translation velocity:(CGPoint)velocity
{
    LMSideBarControllerDirection direction = self.sideBarController.currentDirection;
    LMSideBarControllerState state = self.sideBarController.currentState;
    
    // Transform Animation
    CATransform3D transform = [self contentTransformForState:state direction:direction translation:translation velocity:velocity];
    CAKeyframeAnimation *transformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnim.duration = 0;
    transformAnim.values = @[[NSValue valueWithCATransform3D:transform]];
    
    [self.contentImageView.layer addAnimation:transformAnim forKey:nil];
    [self.contentImageView.layer setValue:[transformAnim.values lastObject] forKeyPath:@"transform"];
    
    // Position Animation
    CGFloat contentPositionX = [self contentPositionXForState:state direction:direction translation:translation velocity:velocity];
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    positionAnim.duration = 0;
    positionAnim.values = @[@(contentPositionX)];
    
    [self.contentImageView.layer addAnimation:positionAnim forKey:nil];
    [self.contentImageView.layer setValue:[positionAnim.values lastObject] forKeyPath:@"position.x"];
}

- (CGFloat)destinationContentScaleForDirection:(LMSideBarControllerDirection)direction velocity:(CGPoint)velocity
{
    if (direction == LMSideBarControllerDirectionLeft) {
        return (velocity.x < 0) ? 1 : self.closedScale;
    }
    else {
        return (velocity.x < 0) ? self.closedScale : 1;
    }
}

- (CGFloat)destinationContentPositionXForDirection:(LMSideBarControllerDirection)direction velocity:(CGPoint)velocity
{
    if (direction == LMSideBarControllerDirectionLeft) {
        if (velocity.x < 0) {
            return originContentCenter.x;
        }
        return originContentCenter.x + animationBounceSize * 2;
    }
    else {
        if (velocity.x < 0) {
            return originContentCenter.x - animationBounceSize * 2;
        }
        return originContentCenter.x;
    }
}

- (NSArray *)contentTransformValuesForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CATransform3D contentTransform = self.contentImageView.layer.transform;
    
    NSMutableArray *values = [NSMutableArray new];
    [values addObject:[NSValue valueWithCATransform3D:contentTransform]];
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        CGFloat scale = self.closedScale - kDefaultAnimationBounceScale;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(self.closedScale, self.closedScale, self.closedScale)]];
    }
    else
    {
        if (self.menuView.layer.presentationLayer.position.x == desMenuCenter.x) {
            CGFloat scale = self.closedScale - kDefaultAnimationBounceScale;
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)]];
        }
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
    
    return values;
}

- (NSArray *)contentPositionXValuesForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    CGFloat currentContentPositionX = self.contentImageView.layer.position.x;
    
    NSMutableArray *values = [NSMutableArray new];
    [values addObject:@(currentContentPositionX)];
    
    if (state == LMSideBarControllerStateWillOpen || state == LMSideBarControllerStateDidOpen)
    {
        if (direction == LMSideBarControllerDirectionLeft) {
            [values addObject:@(originContentCenter.x + animationBounceSize * 2)];
            [values addObject:@(originContentCenter.x + animationBounceSize)];
        }
        else {
            [values addObject:@(originContentCenter.x - animationBounceSize * 2)];
            [values addObject:@(originContentCenter.x - animationBounceSize)];
        }
    }
    else
    {
        if (self.menuView.layer.presentationLayer.position.x == desMenuCenter.x)
        {
            if (direction == LMSideBarControllerDirectionLeft) {
                [values addObject:@(currentContentPositionX + animationBounceSize)];
            }
            else {
                [values addObject:@(currentContentPositionX - animationBounceSize)];
            }
        }
        [values addObject:@(originContentCenter.x)];
    }
    
    return values;
}

- (CGFloat)contentPositionXForState:(LMSideBarControllerState)state
                          direction:(LMSideBarControllerDirection)direction
                        translation:(CGPoint)translation
                           velocity:(CGPoint)velocity
{
    CGFloat menuPositionX1 = self.menuView.layer.position.x;
    CGFloat menuPositionX2 = [self destinationMenuPositionXForDirection:direction velocity:velocity];
    
    CGFloat contentPositionX1 = self.contentImageView.layer.position.x;
    CGFloat contentPositionX2 = [self destinationContentPositionXForDirection:direction velocity:velocity];
    
    CGFloat contentPositionX = contentPositionX1;
    if (menuPositionX2 != menuPositionX1) {
        contentPositionX = contentPositionX + translation.x * (contentPositionX2 - contentPositionX1)/(menuPositionX2 - menuPositionX1);
    }
    
    if (direction == LMSideBarControllerDirectionLeft) {
        contentPositionX = MIN(contentPositionX, originContentCenter.x + animationBounceSize * 2);
        contentPositionX = MAX(contentPositionX, originContentCenter.x);
    }
    else {
        contentPositionX = MIN(contentPositionX, originContentCenter.x);
        contentPositionX = MAX(contentPositionX, originContentCenter.x - animationBounceSize * 2);
    }
    
    return contentPositionX;
}

- (CATransform3D)contentTransformForState:(LMSideBarControllerState)state
                                direction:(LMSideBarControllerDirection)direction
                              translation:(CGPoint)translation
                                 velocity:(CGPoint)velocity
{
    CGFloat menuPositionX1 = self.menuView.layer.position.x;
    CGFloat menuPositionX2 = [self destinationMenuPositionXForDirection:direction velocity:velocity];
    
    CGFloat contentScale1 = [[self.contentImageView.layer valueForKeyPath:@"transform.scale"] floatValue];
    CGFloat contentScale2 = [self destinationContentScaleForDirection:direction velocity:velocity];
    
    CGFloat contentScale = contentScale1;
    if (menuPositionX2 != menuPositionX1) {
        contentScale = contentScale1 + translation.x * (contentScale2 - contentScale1)/(menuPositionX2 - menuPositionX1);
    }
    
    contentScale = MIN(contentScale, 1);
    contentScale = MAX(contentScale, self.closedScale);
    
    return CATransform3DMakeScale(contentScale, contentScale, contentScale);
}

- (NSArray *)contentKeyTimesForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    NSMutableArray *keyTimes = [NSMutableArray new];
    [keyTimes addObject:@(0)];
    [keyTimes addObject:@(0.5)];
    [keyTimes addObject:@(1)];
    return keyTimes;
}

- (NSArray *)contentTimingFunctionsForState:(LMSideBarControllerState)state direction:(LMSideBarControllerDirection)direction
{
    NSMutableArray *timingFunctions = [NSMutableArray new];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

@end
