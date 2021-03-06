//
//  API.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (NSString *)clientId;
+ (NSString *)clientSecret;
+ (NSString *)tokenUrl;
+ (NSString *)profileUrl;
+ (NSString *)pushTokenUrl;
+ (NSString *)shareLocationUrl;

@end
