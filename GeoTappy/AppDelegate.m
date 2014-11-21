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
#import "MainNavigationController.h"
#import "UserDefaults.h"
#import "MapNavigationController.h"
#import <HockeySDK/HockeySDK.h>
#import <DMJobManager/DMJobManager.h>
#import "PushTokenJob.h"
#import "User.h"

#ifdef DEBUG
#import "SDStatusBarManager.h"
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession.activeSession close];
//    [FBSession setActiveSession:nil];
//    [UserDefaults instance].currentUser = nil;
//    [UserDefaults instance].authentication = nil;
//    [UserDefaults instance].pushToken = nil;
//    [application unregisterForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

#ifdef DEBUG
    [[SDStatusBarManager sharedInstance] enableOverrides];
#endif
    
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    if (token) {
    } else {
    }
    
    UILocalNotification* notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
    }

    [DMJobManager startManager];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"df1ffbdc02950279fd07f57c2202f762"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    if ([[UserDefaults instance].currentUser isComplete]) {
        MainNavigationController* mainNavigationController = [[MainNavigationController alloc] init];
        self.window.rootViewController = mainNavigationController;
    } else {
        SplashViewController* splashViewController = [[SplashViewController alloc] init];
        self.window.rootViewController = splashViewController;
    }
    
    NSString* pushToken = [UserDefaults instance].pushToken;
    if (pushToken) {
        PushTokenJob* job = [[PushTokenJob alloc] initWithToken:pushToken];
        [DMJobManager postJob:job];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UserDefaults instance].currentUser refreshWithCompletion:nil];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UserDefaults instance].currentUser refreshWithCompletion:nil];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings NS_AVAILABLE_IOS(8_0) {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString* token = [deviceToken description];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDefaults instance].pushToken = token;
    PushTokenJob* job = [[PushTokenJob alloc] initWithToken:token];
    [DMJobManager postJob:job];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary* location = [[userInfo objectForKey:@"info"] objectForKey:@"location"];
    MapNavigationController* vc = [[MapNavigationController alloc] initWithLocation:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]) name:[[[userInfo objectForKey:@"info"] objectForKey:@"sender"] objectForKey:@"name"]];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)logoutUser {
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [UserDefaults instance].currentUser = nil;
    [UserDefaults instance].authentication = nil;
    SplashViewController* vc = [[SplashViewController alloc] init];
    self.window.rootViewController = vc;
}

@end
