//
//  MainViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "UserDefaults.h"
#import <CoreLocation/CoreLocation.h>

@implementation MainViewController {
    CLLocationManager* _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User* user = [UserDefaults instance].currentUser;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage* coverImage = user.coverImage;
    UIImageView* coverImageView = [[UIImageView alloc] initWithImage:coverImage];
    coverImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:coverImageView];
    
    UIImage* profileImage = user.profileImage;
    UIImageView* profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    profileImageView.frame = CGRectMake(self.view.frame.size.width / 2 - 35, 34, 70, 70);
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = 35;
    profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    profileImageView.layer.borderWidth = 4;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:profileImageView];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, profileImageView.frame.origin.y + profileImageView.frame.size.height + 12, self.view.frame.size.width, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    nameLabel.layer.shadowRadius = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.shadowOpacity = 0.5;
    nameLabel.layer.masksToBounds = NO;
    nameLabel.clipsToBounds = NO;
    nameLabel.text = user.name;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:nameLabel];
    
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 150) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    // this is just to get the permission here in the app
    // has to be an instance var, otherwise it will get released, an the alert view disappears
    // a reason to <3 apple
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
