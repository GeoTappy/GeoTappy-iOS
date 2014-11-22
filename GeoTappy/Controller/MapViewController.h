//
//  MapViewController.h
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location name:(NSString *)name identifier:(NSNumber *)identifier;

@end
