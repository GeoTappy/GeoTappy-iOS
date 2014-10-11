//
//  NullHelper.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "NullHelper.h"

@implementation NullHelper

+ (id)nullOrObject:(id)object {
    if (!object) {
        object = [NSNull null];
    }
    return object;
}

@end
