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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    if (token) {
        SplashViewController* vc = [[SplashViewController alloc] init];
        self.window.rootViewController = vc;
        MainNavigationController* m = [[MainNavigationController alloc] init];
        m.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [vc presentViewController:m animated:NO completion:nil];
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    
    UILocalNotification* notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
    }

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
    if (!token) {
        SplashViewController* vc = [[SplashViewController alloc] init];
        self.window.rootViewController = vc;
    } else {
        SplashViewController* vc = [[SplashViewController alloc] init];
        self.window.rootViewController = vc;
        MainNavigationController* m = [[MainNavigationController alloc] init];
        m.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [vc presentViewController:m animated:NO completion:nil];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"got push: %@", userInfo);
    NSDictionary* location = [[userInfo objectForKey:@"info"] objectForKey:@"location"];
    MapNavigationController* vc = [[MapNavigationController alloc] initWithLocation:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]) name:[[[userInfo objectForKey:@"info"] objectForKey:@"sender"] objectForKey:@"name"]];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

@end
