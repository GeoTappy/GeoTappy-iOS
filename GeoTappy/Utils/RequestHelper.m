//
//  RequestHelper.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "RequestHelper.h"
#import "UserDefaults.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NullHelper.h"
#import "Authentication.h"

@implementation RequestHelper

+ (NSMutableDictionary *)emptyJsonRequest {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserDefaults instance].authentication.accessToken forKey:@"access_token"];
    return dict;
}

+ (void)startRequest:(NSMutableURLRequest *)request completion:(CompletionBlockWithData)completion {
    
    // check if access token is still valid
    if ([[UserDefaults instance].authentication.expiration timeIntervalSinceReferenceDate] >= [[NSDate date] timeIntervalSinceReferenceDate]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response,
                                                   NSData* data,
                                                   NSError* error) {
                                   if (!error && data) {
                                       completion(YES, data);
                                   } else {
                                       // check if token expired etc
                                       [RequestHelper refreshAccessTokenWithCompletion:^(BOOL success) {
                                           if (success) {
                                               // do the request again
                                               [RequestHelper startRequest:request completion:completion];
                                           } else {
                                               completion(NO, nil);
                                           }
                                       }];
                                   }
                               }];
    } else {
        [RequestHelper refreshAccessTokenWithCompletion:^(BOOL success) {
            if (success) {
                // do the request again
                [RequestHelper startRequest:request completion:completion];
            } else {
                completion(NO, nil);
            }
        }];
    }
    
}

+ (void)createAccessTokenWithCompletion:(CompletionBlock)completion {
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:@"8a29d0a7d2a0738fd25398f4f5d79c126055c0ebe98e68da455875b95c9bec53" forKey:@"client_id"];
    [jsonDict setObject:@"95285bce939a16d57de005bc1ec690357c10191bc71b1f4cb996427c421eb6b9" forKey:@"client_secret"];
    [jsonDict setObject:@"password" forKey:@"grant_type"];
    [jsonDict setObject:@"facebook" forKey:@"provider"];
    [jsonDict setObject:token forKey:@"token"];
    NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API tokenUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error) {
                               if (!error && data) {
                                   NSError* jsonError;
                                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                                   if (!jsonError) {
                                       Authentication* authentication = [[Authentication alloc] init];
                                       authentication.accessToken = [json objectForKey:@"access_token"];
                                       authentication.refreshToken = [json objectForKey:@"refresh_token"];
                                       authentication.expiration = [NSDate dateWithTimeIntervalSinceNow:[[json objectForKey:@"expires_in"] doubleValue]];
                                       [UserDefaults instance].authentication = authentication;
                                       completion(YES);
                                   } else {
                                       completion(NO);
                                   }
                               } else {
                                   completion(NO);
                               }
                           }];
}

+ (void)refreshAccessTokenWithCompletion:(CompletionBlock)completion {

}

@end
