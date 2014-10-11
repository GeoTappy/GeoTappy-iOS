//
//  AppDelegate.m
//  GeoTappy
//
//  Created by Dylan Marriott on 10/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import "UserDefaults.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession.activeSession close];
//    [FBSession setActiveSession:nil];
//    [[UserDefaults instance] reset];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0) {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString* token = [deviceToken description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDefaults instance].pushToken = token;
    [self openApp];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [self openApp];
}

- (void)openApp {
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    if (token) {
        MainViewController* mainViewController = [[MainViewController alloc] init];
        self.window.rootViewController = mainViewController;
    } else {
        SplashViewController* splashViewController = [[SplashViewController alloc] init];
        self.window.rootViewController = splashViewController;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}

@end
