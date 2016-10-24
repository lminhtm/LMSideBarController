//
//  LMSideBarDepthStyle.h
//  LMSideBarController
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMSideBarStyle.h"

/**
 Depth side bar style class.
 */
@interface LMSideBarDepthStyle : LMSideBarStyle

/**
 The closed scale of content view. Set it to 1 to disable content scale animation. Default is 0.8
 */
@property (nonatomic, assign) CGFloat closedScale;

/**
 A boolean indicates whether content view should be blurred. Default is YES
 */
@property (nonatomic, assign) BOOL shouldBlurContentView;

/**
 The blur radius of container view. Default is 5
 */
@property (nonatomic, assign) CGFloat blurRadius;

/**
 The alpha of black mask button. Default is 0.4
 */
@property (nonatomic, assign) CGFloat blackMaskAlpha;

@end
