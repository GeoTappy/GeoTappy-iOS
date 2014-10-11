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

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User* user = [UserDefaults instance].currentUser;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImage* coverImage = user.coverImage;
    UIImageView* coverImageView = [[UIImageView alloc] initWithImage:coverImage];
    coverImageView.frame = CGRectMake(0, 80, self.view.frame.size.width, 200);
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:coverImageView];
    
    UIImage* profileImage = user.profileImage;
    UIImageView* profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    profileImageView.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 140, 80, 80);
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = 40;
    profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    profileImageView.layer.borderWidth = 5;
    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:profileImageView];
}

@end
