//
//  API.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "API.h"

@implementation API

static NSString* BASE_URL = @"http://geo-tappy.herokuapp.com/api/v1/";

+ (NSString *)facebookRegisterUrl {
    return [NSString stringWithFormat:@"%@%@", BASE_URL, @"token"];
}

@end
