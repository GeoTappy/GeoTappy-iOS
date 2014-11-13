//
//  MapViewController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 12/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@implementation MapViewController {
    CLLocationCoordinate2D _location;
    NSString* _name;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location name:(NSString *)name {
    if (self = [super init]) {
        _location = location;
        _name = name;
        UIBarButtonItem* closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
        self.navigationItem.leftBarButtonItem = closeItem;
    }
    return self;
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MKMapView* mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.centerCoordinate = _location;
    MapAnnotation* annotation = [[MapAnnotation alloc] initWithCoordinate:_location title:_name];
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:YES];
    [self.view addSubview:mapView];
}

@end
