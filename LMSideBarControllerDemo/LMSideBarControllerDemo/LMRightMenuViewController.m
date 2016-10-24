//
//  LMRightMenuViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LMRightMenuViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "LMMessageCell.h"

@interface LMRightMenuViewController ()

@property (nonatomic, strong) NSArray *messageDicts;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LMRightMenuViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageDicts = @[@{@"name":@"Yoona", @"content":@"Hello, it's me", @"image":@"yoona"},
                          @{@"name":@"Suzy", @"content":@"I was wondering", @"image":@"suzy"},
                          @{@"name":@"Jun Vu", @"content":@"If after all these years", @"image":@"junvu"},
                          @{@"name":@"Minh Hang", @"content":@"you'd like to meet", @"image":@"minhhang"},
                          @{@"name":@"Sulli", @"content":@"Hello, can you hear me?", @"image":@"sulli"},
                          @{@"name":@"Nozomi Sasaki", @"content":@"Hello, how are you?", @"image":@"nozomisasaki"},
                          @{@"name":@"Jessica", @"content":@"Hello from the other side", @"image":@"jessica"},
                          @{@"name":@"Krystal", @"content":@"I must've called a thousand times", @"image":@"krystal"},
                          ];
}


#pragma mark - TABLE VIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageDicts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    NSDictionary *messageDict = [self.messageDicts objectAtIndex:indexPath.row];
    cell.nameLabel.text = [messageDict objectForKey:@"name"];
    cell.contentLabel.text = [messageDict objectForKey:@"content"];
    cell.avatarImageView.image = [UIImage imageNamed:[messageDict objectForKey:@"image"]];
    
    return cell;
}


#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.sideBarController hideMenuViewController:YES];
}

@end
