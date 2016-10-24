//
//  UIImage+LMExtension.h
//
//  Created by LMinh on 28/12/2013.
//  Copyright (c) 2013 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (LMExtension)

/**
 Screen shot from view.
 */
+ (UIImage *)imageFromView:(UIView *)theView withSize:(CGSize)size;

/**
 Blur image
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor;

@end
