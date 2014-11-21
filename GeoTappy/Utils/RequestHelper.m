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

+ (void)startRequest:(NSMutableURLRequest *)request completion:(RequestHelperCompletionBlockWithData)completion {
    [RequestHelper startRequest:request completion:completion retry:YES];
}

+ (void)startRequest:(NSMutableURLRequest *)request completion:(RequestHelperCompletionBlockWithData)completion retry:(BOOL)retry {
    // check if access token is still valid
    if ([[UserDefaults instance].authentication.expiration timeIntervalSinceReferenceDate] >= [[NSDate date] timeIntervalSinceReferenceDate]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSLog(@"Calling: %@", request.URL);
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response,
                                                   NSData* data,
                                                   NSError* error) {
                                   NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                   if (!error && httpResponse.statusCode == 200 && data) {
                                       NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                       completion(YES, data);
                                   } else {
                                       // check if token expired etc
                                       [RequestHelper refreshAccessTokenWithCompletion:^(BOOL success) {
                                           if (!success && retry) {
                                               // do the request again
                                               [RequestHelper startRequest:request completion:completion retry:NO];
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

+ (void)createAccessTokenWithCompletion:(RequestHelperCompletionBlock)completion {
    NSString* token = FBSession.activeSession.accessTokenData.accessToken;
    [self doAuthRequestWithGrantType:@"password" token:token completion:completion];
}

+ (void)refreshAccessTokenWithCompletion:(RequestHelperCompletionBlock)completion {
    NSString* token = [UserDefaults instance].authentication.refreshToken;
    [self doAuthRequestWithGrantType:@"refresh_token" token:token completion:completion];
}

+ (void)doAuthRequestWithGrantType:(NSString *)grantType token:(NSString *)token completion:(RequestHelperCompletionBlock)completion {
    NSMutableDictionary* jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:[API clientId] forKey:@"client_id"];
    [jsonDict setObject:[API clientSecret] forKey:@"client_secret"];
    [jsonDict setObject:grantType forKey:@"grant_type"];
    if ([grantType isEqualToString:@"password"]) {
        [jsonDict setObject:@"facebook" forKey:@"provider"];
        [jsonDict setObject:token forKey:@"token"];
    } else if ([grantType isEqualToString:@"refresh_token"]) {
        [jsonDict setObject:token forKey:@"refresh_token"];
    } else {
        NSAssert(NO, @"Unknown grant type");
    }
    NSData* json = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[API tokenUrl]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:json];
    
    NSLog(@"Doing auth: %@", grantType);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error) {
                               NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                               if (!error && httpResponse.statusCode == 200 && data) {
                                   NSLog(@"Auth response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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

@end
