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
//
//    UIVibrancyEffect* vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    UIVisualEffectView* vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    self.view.addSubview(vibrancyEffectView)
//
    FBLoginView* fbLogin = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"publish_stream"]];
    fbLogin.frame = CGRectMake((self.view.frame.size.width / 2) - (fbLogin.frame.size.width / 2), self.view.frame.size.height - 80, fbLogin.frame.size.width, fbLogin.frame.size.height);
    fbLogin.delegate = self;
    [self.view addSubview:fbLogin];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.alpha = 1.0;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [UIView animateWithDuration:0.3 animations:^() {
        loginView.alpha = 0.0;
    }];

    [RequestHelper createAccessTokenWithCompletion:^(BOOL sucess) {
        if (sucess) {
            NSString* url = [NSString stringWithFormat:@"%@?access_token=%@", [API profileUrl], [UserDefaults instance].authentication.accessToken];
            NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [RequestHelper startRequest:request completion:^(BOOL success, NSData* data) {
                NSError* jsonError;
                //NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary* profile = [json objectForKey:@"profile"];
                User* user = [self userFromJson:profile];
                NSMutableArray* friends = [NSMutableArray array];
                for (NSDictionary* friend in [profile objectForKey:@"friends"]) {
                    [friends addObject:[self userFromJson:friend]];
                }
                user.friends = [NSArray arrayWithArray:friends];
                
                int i = 0;
                for (User* u in friends) {
                    if (i < 3) {
                        [user.selectedFavourites addObject:u];
                    } else {
                        [user.unselectedFavourites addObject:u];
                    }
                    i++;
                }
                [user save];
                
                [spinner stopAnimating];
                
                if ([self presentingViewController] == nil) {
                    MainNavigationController* vc = [[MainNavigationController alloc] init];
                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    self.view.window.rootViewController = vc;
                } else {
                    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        } else {
            // handle error
        }
    }];
}

- (User *)userFromJson:(NSDictionary *)json {
    User* user = [[User alloc] init];
    user.coverImage = [self downloadImage:[json objectForKey:@"cover_photo_url"]];
    user.profileImage = [self downloadImage:[json objectForKey:@"profile_photo_url"]];
    user.name = [json objectForKey:@"name"];
    user.identifier = [json objectForKey:@"id"];
    return user;
}

- (UIImage *)downloadImage:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [[UIImage alloc] initWithData:data];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
