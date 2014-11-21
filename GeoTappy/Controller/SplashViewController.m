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
#import "UIBAlertView.h"
#import "AppDelegate.h"

@interface SplashViewController () <FBLoginViewDelegate>

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* backgroundImage = [UIImage imageNamed:@"background"];
    UIImageView* backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = backgroundImage;
    float imgFactor = backgroundImage.size.height / backgroundImage.size.width;
    backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * imgFactor);
    [self.view addSubview:backgroundImageView];

    FBLoginView* fbLogin = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"publish_stream"]];
    fbLogin.frame = CGRectMake((self.view.frame.size.width / 2) - (fbLogin.frame.size.width / 2), self.view.frame.size.height - 80, fbLogin.frame.size.width, fbLogin.frame.size.height);
    fbLogin.delegate = self;
    [self.view addSubview:fbLogin];

    self.view.backgroundColor = [UIColor colorWithRed:8.0f / 255 green:112.0f / 255 blue:209.0f / 255 alpha:1.0f];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.alpha = 1.0;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    loginView.alpha = 0.0;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height - 100);
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
                if ([user isComplete]) {
                    [spinner stopAnimating];
                    MainNavigationController* vc = [[MainNavigationController alloc] init];
                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    self.view.window.rootViewController = vc;
                } else {
                    [self handleError];
                }
            }];
        } else {
            [self handleError];
        }
    }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    [self handleError];
}

- (void)handleError {
    UIBAlertView* av = [[UIBAlertView alloc] initWithTitle:@"Error" message:@"Authentication failed, please try again." cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [av showWithDismissHandler:^(NSInteger selectedIndex, NSString* selectedTitle, BOOL didCancel) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) logoutUser];
    }];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
