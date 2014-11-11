//
//  API.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "API.h"

@implementation API

static NSString* BASE_URL = @"http://api.geotappy.com/";

+ (NSString *)tokenUrl {
    return [self baseUrlWithSuffix:@"oauth/token.json"];
}

+ (NSString *)profileUrl {
    return [self urlWithSuffix:@"profile.json"];
}

+ (NSString *)pushTokenUrl {
    return [self urlWithSuffix:@"profile/token.json"];
}

+ (NSString *)shareLocationUrl {
    return [self urlWithSuffix:@"location_shares"];
}

+ (NSString *)baseUrlWithSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@%@", BASE_URL, suffix];
}

+ (NSString *)urlWithSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@api/v1/%@", BASE_URL, suffix];
}

@end
