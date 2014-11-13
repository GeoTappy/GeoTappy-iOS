//
//  MapAnnotation.m
//  GeoTappy
//
//  Created by Dylan Marriott on 13.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
    }
    return self;
}

@end
