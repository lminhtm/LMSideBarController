//
//  LeftMenuViewController.m
//  LMSideBarControllerDemo
//
//  Created by LMinh on 10/11/15.
//  Copyright © 2015 LMinh. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+LMSideBarController.h"
#import "MainNavigationController.h"

@interface LeftMenuViewController ()

@property (nonatomic, strong) NSArray *menuTitles;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation LeftMenuViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[@"Home", @"Profile", @"Chats", @"Settings", @"About"];
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 50.0;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 3.0f;
    self.avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.avatarImageView.layer.shouldRasterize = YES;
}


#pragma mark - TABLE VIEW DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.menuTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.11 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - TABLE VIEW DELEGATE

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.sideBarController hideMenuViewController:YES];
    
    MainNavigationController *navigationController = (MainNavigationController *)self.sideBarController.contentViewController;
    NSString *menuTitle = self.menuTitles[indexPath.row];
    if ([menuTitle isEqualToString:@"Home"]) {
        [navigationController showHomeViewController];
    }
    else if ([menuTitle isEqualToString:@"Profile"]) {
        [navigationController showProfileViewController];
    }
    else if ([menuTitle isEqualToString:@"Chats"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.sideBarController showMenuViewControllerInDirection:LMSideBarControllerDirectionRight];
        });
    }
    else if ([menuTitle isEqualToString:@"Settings"]) {
        [navigationController showSettingsViewController];
    }
    else if ([menuTitle isEqualToString:@"About"]) {
        [navigationController showAboutViewController];
    }
}

@end
