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

@interface TodayViewController () <NCWidgetProviding, CLLocationManagerDelegate>

@end

@implementation TodayViewController {
    NSMutableArray* _profileViews;
    CLLocationManager* _locationManager;
    CLLocation* _currentLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationManager requestWhenInUseAuthorization];
    
    self.preferredContentSize = CGSizeMake(200, 105);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    UIEdgeInsets newInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    return newInsets;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User* user = [UserDefaults instance].currentUser;
    _profileViews = [NSMutableArray array];
    for (id<Favourite> favourite in user.selectedFavourites) {
        NSMutableArray* images = [NSMutableArray array];
        if ([favourite isKindOfClass:[User class]]) {
            if (((User *)favourite).profileImage != nil) {
                [images addObject:((User *)favourite).profileImage];
            }
        } else if ([favourite isKindOfClass:[Group class]]) {
            for (User* u in ((Group *)favourite).users) {
                if (u.profileImage != nil) {
                    [images addObject:u.profileImage];
                }
            }
        }
        ProfileView* pv = [[ProfileView alloc] initWithFrame:CGRectMake(0, 0, 44, 44) images:images];
        [pv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTap:)]];
        [_profileViews addObject:pv];
    }
    
    HorizontalScroller* scroller = [[HorizontalScroller alloc] initWithViews:_profileViews];
    scroller.view.frame = CGRectMake(0, 30, 200, 44);
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
        User* friend = (User *)favourite;
        [self sendLocationToUsers:@[friend] completion:^(BOOL success) {
            [self performSelector:@selector(turnOfLoading:) withObject:view afterDelay:0.5];
        }];
    } else if ([favourite isKindOfClass:[Group class]]) {
        [self sendLocationToUsers:((Group *)favourite).users completion:^(BOOL success) {
            [self performSelector:@selector(turnOfLoading:) withObject:view afterDelay:0.5];
        }];
    }
}

- (void)turnOfLoading:(ProfileView *)view {
    [view setLoading:NO];
    [view showSuccess];
}

- (void)sendLocationToUsers:(NSArray *)users completion:(void (^)(BOOL))completion {
    NSMutableDictionary* jsonDict = [RequestHelper emptyJsonRequest];
    NSMutableDictionary* locationShare = [NSMutableDictionary dictionary];
    [locationShare setObject:@"" forKey:@"title"];
    NSMutableArray* userIds = [NSMutableArray array];
    for (User* user in users) {
        [userIds addObject:user.identifier];
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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (data && !error) {
                                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSLog(@"result: %@", json);
                                   completion(YES);
                               } else {
                                   NSLog(@"error: %@", error);
                                   completion(NO);
                               }
                               
                           }];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    NSLog(@"widgetPerformUpdateWithCompletionHandler");
    completionHandler(NCUpdateResultNoData);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status: %i", status);
}

@end
