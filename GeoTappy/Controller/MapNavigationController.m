//
//  MapNavigationController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MapNavigationController.h"
#import "MapViewController.h"

@implementation MapNavigationController

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location name:(NSString *)name {
    if (self = [super init]) {
        MapViewController* vc = [[MapViewController alloc] initWithLocation:location name:name];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

@end
