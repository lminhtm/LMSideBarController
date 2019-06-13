//
//  MessageCell.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/23/16.
//  Copyright © 2016 LMinh. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 20;
}

@end
