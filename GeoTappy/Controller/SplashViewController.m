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
#import "NullHelper.h"

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
    [jsonDict setObject:[NullHelper nullOrObject:[UserDefaults instance].pushToken] forKey:@"push_token"];
    NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API facebookRegisterUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    spinner.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               
                               
                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary* profile = [json objectForKey:@"profile"];
                               User* user = [self userFromJson:profile];
                               NSMutableArray* friends = [NSMutableArray array];
                               for (NSDictionary* friend in [profile objectForKey:@"friends"]) {
                                   [friends addObject:[self userFromJson:friend]];
                               }
                               user.friends = friends;
                               user.unselectedFavourites = friends; // just temporary
                               [UserDefaults instance].currentUser = user;
                               [UserDefaults instance].accessToken = [profile objectForKey:@"access_token"];

                               [spinner stopAnimating];

                               self.view.window.rootViewController = [[MainViewController alloc] init];
                               
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
