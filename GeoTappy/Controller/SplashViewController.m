//
//  SplashViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 10/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "SplashViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import "User.h"
#import "UserDefaults.h"

@interface SplashViewController () <FBLoginViewDelegate>

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView* backgroundImage = [[UIImageView alloc] init];
    backgroundImage.frame = self.view.bounds;
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    backgroundImage.image = [UIImage imageNamed:@"background"];
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    [self.view addSubview:backgroundImage];
    [self.view addSubview:blurEffectView];
//
//    UIVibrancyEffect* vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    UIVisualEffectView* vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    self.view.addSubview(vibrancyEffectView)
//
    FBLoginView* fbLogin = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends", @"email"]];
    fbLogin.frame = CGRectMake((self.view.frame.size.width / 2) - (fbLogin.frame.size.width / 2), self.view.frame.size.height - 80, fbLogin.frame.size.width, fbLogin.frame.size.height);
    fbLogin.delegate = self;
    [self.view addSubview:fbLogin];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* auth = [[NSMutableDictionary alloc] init];
    [auth setObject:@"facebook" forKey:@"provider"];
    [auth setObject:token forKey:@"token"];
    [jsonDict setObject:auth forKey:@"auth"];
    NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API facebookRegisterUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               
                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               User* user = [[User alloc] init];
                               user.coverImage = [self downloadImage:[[json objectForKey:@"profile"] objectForKey:@"cover_photo_url"]];
                               user.profileImage = [self downloadImage:[[json objectForKey:@"profile"] objectForKey:@"profile_photo_url"]];
                               [UserDefaults instance].currentUser = user;
                               self.view.window.rootViewController = [[MainViewController alloc] init];
                               
                           }];
}

- (UIImage *)downloadImage:(NSString *)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [[UIImage alloc] initWithData:data];
}

@end
