//
//  RequestHelper.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "RequestHelper.h"
#import "UserDefaults.h"

@implementation RequestHelper

+ (NSMutableDictionary *)emptyJsonRequest {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[UserDefaults instance].accessToken forKey:@"access_token"];
    return dict;
}

@end
