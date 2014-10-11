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

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController {
    NSMutableArray* _profileViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(200, 200);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User* user = [UserDefaults instance].currentUser;
    _profileViews = [NSMutableArray array];
    for (id<Favourite> favourite in user.favourites) {
        NSMutableArray* images = [NSMutableArray array];
        if ([favourite isKindOfClass:[User class]]) {
            [images addObject:((User *)favourite).profileImage];
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
    
}

- (void)profileTap:(UITapGestureRecognizer *)sender {
    ProfileView* view = (ProfileView *)sender.view;
    [view setLoading:YES];
    NSUInteger index = [_profileViews indexOfObject:view];
    User* user = [UserDefaults instance].currentUser;
    id<Favourite> favourite = [user.favourites objectAtIndex:index];
    if ([favourite isKindOfClass:[User class]]) {
        User* friend = (User *)favourite;
        [self sendLocationToUsers:@[friend] completion:^(BOOL success) {
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
    [location setObject:@40.7056308 forKey:@"lat"];
    [location setObject:@-73.9780035 forKey:@"lng"];
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

    completionHandler(NCUpdateResultNewData);
}



@end
