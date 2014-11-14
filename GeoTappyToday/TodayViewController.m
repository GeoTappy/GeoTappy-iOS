//
//  TodayViewController.m
//  GeoTappyToday
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "ProfileView.h"
#import "HorizontalScroller.h"
#import "UserDefaults.h"
#import "User.h"
#import "RequestHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "Group.h"
#import <HockeySDK/HockeySDK.h>
#import "Friend.h"

@interface TodayViewController () <NCWidgetProviding, CLLocationManagerDelegate>

@end

@implementation TodayViewController {
    NSMutableArray* _profileViews;
    CLLocationManager* _locationManager;
    CLLocation* _currentLocation;
    BOOL _didSetupHockeySDK;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_didSetupHockeySDK) {
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"df1ffbdc02950279fd07f57c2202f762"];
        [[BITHockeyManager sharedHockeyManager] startManager];
        _didSetupHockeySDK = YES;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestWhenInUseAuthorization];
    
    self.preferredContentSize = CGSizeMake(320, 125);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    UIEdgeInsets newInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    return newInsets;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User* user = [UserDefaults instance].currentUser;
    _profileViews = [NSMutableArray array];
    NSMutableArray* displayViews = [NSMutableArray array];
    for (id<Favourite> favourite in user.selectedFavourites) {
        NSMutableArray* images = [NSMutableArray array];
        if ([favourite isKindOfClass:[User class]]) {
            if (((Friend *)favourite).profileImage != nil) {
                [images addObject:((User *)favourite).profileImage];
            }
        } else if ([favourite isKindOfClass:[Group class]]) {
            for (Friend* f in ((Group *)favourite).friends) {
                if (f.profileImage != nil) {
                    [images addObject:f.profileImage];
                }
            }
        }
        
        UIView* wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 74)];
        ProfileView* pv = [[ProfileView alloc] initWithFrame:CGRectMake(3, 0, 44, 44) images:images];
        [pv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTap:)]];
        [wrapper addSubview:pv];
        
        UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 20)];
        name.font = [UIFont systemFontOfSize:11];
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentCenter;
        name.text = [favourite shortDisplayName];
        [wrapper addSubview:name];
        
        [_profileViews addObject:pv];
        [displayViews addObject:wrapper];
    }
    
    HorizontalScroller* scroller = [[HorizontalScroller alloc] initWithViews:displayViews];
    scroller.view.frame = CGRectMake(0, 30, self.view.bounds.size.width, 44);
    scroller.padding = UIOffsetMake(10, 0);
    [self addChildViewController:scroller];
    [self.view addSubview:scroller.view];
    
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_locationManager stopUpdatingLocation];
}

- (void)profileTap:(UITapGestureRecognizer *)sender {
    ProfileView* view = (ProfileView *)sender.view;
    [view setLoading:YES];
    NSUInteger index = [_profileViews indexOfObject:view];
    User* user = [UserDefaults instance].currentUser;
    id<Favourite> favourite = [user.selectedFavourites objectAtIndex:index];
    if ([favourite isKindOfClass:[User class]]) {
        Friend* friend = (Friend *)favourite;
        [self sendLocationToFriends:@[friend] completion:^(BOOL success) {
            [self handleResponse:success view:view];
        }];
    } else if ([favourite isKindOfClass:[Group class]]) {
        [self sendLocationToFriends:((Group *)favourite).friends completion:^(BOOL success) {
            [self handleResponse:success view:view];
        }];
    }
}

- (void)handleResponse:(BOOL)success view:(ProfileView *)view {
    if (success) {
        [self performSelector:@selector(showSuccess:) withObject:view afterDelay:0.5];
    } else {
        [self performSelector:@selector(showError:) withObject:view afterDelay:0.5];
    }
}

- (void)showSuccess:(ProfileView *)view {
    [view setLoading:NO];
    [view showSuccess];
}

- (void)showError:(ProfileView *)view {
    [view setLoading:NO];
    [view showError];
}

- (void)sendLocationToFriends:(NSArray *)friends completion:(void (^)(BOOL))completion {
    NSMutableDictionary* jsonDict = [RequestHelper emptyJsonRequest];
    NSMutableDictionary* locationShare = [NSMutableDictionary dictionary];
    [locationShare setObject:@"" forKey:@"title"];
    NSMutableArray* userIds = [NSMutableArray array];
    for (Friend* friend in friends) {
        [userIds addObject:friend.identifier];
    }
    [locationShare setObject:userIds forKey:@"user_ids"];
    NSMutableDictionary* location = [NSMutableDictionary dictionary];
    [location setObject:@(_currentLocation.coordinate.latitude) forKey:@"lat"];
    [location setObject:@(_currentLocation.coordinate.longitude) forKey:@"lng"];
    [locationShare setObject:location forKey:@"location"];
    [jsonDict setObject:locationShare forKey:@"location_share"];
    
    NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API shareLocationUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    
    [RequestHelper startRequest:request completion:^(BOOL success, NSData* data) {
        completion(success);
    }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
}

@end
