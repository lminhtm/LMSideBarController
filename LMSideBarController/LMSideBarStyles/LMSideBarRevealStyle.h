//
//  LMSideMenuParallaxStyle.h
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarStyle.h"

@interface LMSideBarRevealStyle : LMSideBarStyle

@property (nonatomic, assign) BOOL hasParallaxEffect;
@property (nonatomic, assign) BOOL hasScaleEffect;
@property (nonatomic, assign) BOOL hasFadeEffect;
@property (nonatomic, assign) BOOL hasShadow;
@property (nonatomic, assign) BOOL shouldAlignStatusBar;

@property (nonatomic, assign) CGFloat parallaxOffsetFraction;
@property (nonatomic, assign) CGFloat closedScale;
@property (nonatomic, assign) CGFloat closedAlpha;

@end
