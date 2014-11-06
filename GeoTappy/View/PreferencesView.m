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

@interface PreferencesView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation PreferencesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        
        
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 50)];
        footerView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
        UILabel* creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.frame.size.width, footerView.frame.size.height)];
        creditLabel.font = [UIFont systemFontOfSize:11];
        creditLabel.textColor = [UIColor colorWithWhite:0.65 alpha:1.0];
        creditLabel.text = @"Created by Dylan Marriott\nand Konrad Oleksiuk";
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Rate App";
        cell.imageView.image = [UIImage imageNamed:@"rate"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Logout";
        cell.imageView.image = [UIImage imageNamed:@"logout"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
