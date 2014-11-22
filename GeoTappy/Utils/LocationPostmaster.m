//
//  LocationPostmaster.m
//  GeoTappy
//
//  Created by Dylan Marriott on 14.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "LocationPostmaster.h"
#import "Friend.h"
#import "RequestHelper.h"

@implementation LocationPostmaster

+ (void)shareLocation:(CLLocation *)location toFriends:(NSArray *)friends completion:(void (^)(BOOL))completion {
    NSMutableArray* userIds = [NSMutableArray array];
    for (Friend* friend in friends) {
        [userIds addObject:friend.identifier];
    }
    [LocationPostmaster shareLocation:location toUserIds:userIds completion:completion];
}

+ (void)shareLocation:(CLLocation *)location toUserIds:(NSArray *)userIds completion:(void (^)(BOOL))completion {
    NSMutableDictionary* jsonDict = [RequestHelper emptyJsonRequest];
    NSMutableDictionary* locationShare = [NSMutableDictionary dictionary];
    [locationShare setObject:@"" forKey:@"title"];
    [locationShare setObject:userIds forKey:@"user_ids"];
    NSMutableDictionary* locationDict = [NSMutableDictionary dictionary];
    [locationDict setObject:@(location.coordinate.latitude) forKey:@"lat"];
    [locationDict setObject:@(location.coordinate.longitude) forKey:@"lng"];
    [locationShare setObject:locationDict forKey:@"location"];
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

@end
