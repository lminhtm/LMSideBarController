//
//  LMMessageCell.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/23/16.
//  Copyright © 2016 LMinh. All rights reserved.
//

#import "LMMessageCell.h"

@implementation LMMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
}

@end
