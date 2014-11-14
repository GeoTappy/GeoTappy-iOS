//
//  PushTokenJob.m
//  GeoTappy
//
//  Created by Dylan Marriott on 03/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "PushTokenJob.h"
#import "UserDefaults.h"
#import "Authentication.h"
#import "RequestHelper.h"

@implementation PushTokenJob {
    NSString* _token;
}

- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_token forKey:@"token"];
}

- (void)executeWithCompletion:(CompletionBlock)completion {
    if ([UserDefaults instance].authentication == nil) {
        completion(NO);
    } else {
        NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
        [jsonDict setObject:[UserDefaults instance].authentication.accessToken forKey:@"access_token"];
        NSMutableDictionary* user = [NSMutableDictionary dictionary];
        [user setObject:_token forKey:@"token"];
        [jsonDict setObject:user forKey:@"user"];
        NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API pushTokenUrl]]];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:json];
        
        [RequestHelper startRequest:request completion:^(BOOL success, NSData* response) {
            completion(success);
        }];
    }
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[PushTokenJob class]];
}

@end
