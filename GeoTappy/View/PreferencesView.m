//
//  PreferencesView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 06/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PreferencesView.h"
#import "User.h"
#import "UserDefaults.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SplashViewController.h"
#import "AppDelegate.h"

@interface PreferencesView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation PreferencesView {
    __weak id<PreferencesViewDelegate> _delegate;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PreferencesViewDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        User* user = [UserDefaults instance].currentUser;
        UIImageView* headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        headerView.image = user.coverImage;
        
        UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView* backgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        backgroundEffectView.frame = headerView.frame;
        [headerView addSubview:backgroundEffectView];
        
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.text = user.displayName;
        UIVisualEffectView* foregroundEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blurEffect]];
        foregroundEffectView.frame = nameLabel.frame;
        [foregroundEffectView.contentView addSubview:nameLabel];
        [backgroundEffectView.contentView addSubview:foregroundEffectView];
        [self addSubview:headerView];
        
        
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 60, frame.size.width, 60)];
        footerView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
        UILabel* creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.frame.size.width, footerView.frame.size.height)];
        creditLabel.font = [UIFont systemFontOfSize:11];
        creditLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1.0];
        NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString* build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        creditLabel.text = [NSString stringWithFormat:@"Version %@ (%@)\nCreated by Dylan Marriott\nand Konrad Oleksiuk", version, build];
        creditLabel.numberOfLines = 0;
        creditLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:creditLabel];
        [self addSubview:footerView];
        
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, frame.size.width, frame.size.height - headerView.frame.size.height - footerView.frame.size.height)];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Rate App";
        cell.imageView.image = [UIImage imageNamed:@"rate"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Contact";
        cell.imageView.image = [UIImage imageNamed:@"mail"];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Logout";
        cell.imageView.image = [UIImage imageNamed:@"logout"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/941578877"]];
    } else if (indexPath.row == 1) {
        [_delegate openMail];
    } else if (indexPath.row == 2) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        [UserDefaults instance].currentUser = nil;
        [UserDefaults instance].authentication = nil;
        SplashViewController* vc = [[SplashViewController alloc] init];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = vc;
    }
}

@end
