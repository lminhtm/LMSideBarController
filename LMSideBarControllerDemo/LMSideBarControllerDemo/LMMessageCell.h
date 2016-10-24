//
//  LMMessageCell.h
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/23/16.
//  Copyright © 2016 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
