//
//  SplashViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 10/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "SplashViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import "UserDefaults.h"
#import "NullHelper.h"
#import "MainNavigationController.h"
#import "Authentication.h"
#import "RequestHelper.h"

@interface SplashViewController () <FBLoginViewDelegate>

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView* backgroundImage = [[UIImageView alloc] init];
    backgroundImage.frame = self.view.bounds;
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    backgroundImage.image = [UIImage imageNamed:@"background"];
    
    [self.view addSubview:backgroundImage];

    FBLoginView* fbLogin = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"publish_stream"]];
    fbLogin.frame = CGRectMake((self.view.frame.size.width / 2) - (fbLogin.frame.size.width / 2), self.view.frame.size.height - 80, fbLogin.frame.size.width, fbLogin.frame.size.height);
    fbLogin.delegate = self;
    [self.view addSubview:fbLogin];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.alpha = 1.0;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    loginView.alpha = 0.0;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, 370);
    spinner.hidesWhenStopped = YES;
    spinner.alpha = 0.0;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [UIView animateWithDuration:0.5 delay:0.1 options:0 animations:^() {
        spinner.alpha = 1.0;
    } completion:nil];

    [RequestHelper createAccessTokenWithCompletion:^(BOOL sucess) {
        if (sucess) {
            
            User* user = [UserDefaults instance].currentUser;
            if (user == nil) {
                user = [[User alloc] init];
                [UserDefaults instance].currentUser = user;
            }
            
            [user refreshWithCompletion:^() {
                [spinner stopAnimating];
                MainNavigationController* vc = [[MainNavigationController alloc] init];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                self.view.window.rootViewController = vc;
            }];
            
        } else {
            // handle error
        }
    }];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
