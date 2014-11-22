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
#import "LocationPostmaster.h"
#import "UIBAlertView.h"

@implementation MapViewController {
    CLLocationCoordinate2D _location;
    NSString* _name;
    NSNumber* _identifier;
    UIAlertView* _loadingAlert;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)location name:(NSString *)name identifier:(NSNumber *)identifier {
    if (self = [super init]) {
        _location = location;
        _name = name;
        _identifier = identifier;
        UIBarButtonItem* closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close:)];
        self.navigationItem.leftBarButtonItem = closeItem;
        
        UIBarButtonItem* shareItem = [[UIBarButtonItem alloc] initWithTitle:@"Ping Back" style:UIBarButtonItemStylePlain target:self action:@selector(pingBack:)];
        self.navigationItem.rightBarButtonItem = shareItem;
    }
    return self;
}

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pingBack:(id)sender {
    _loadingAlert = [[UIAlertView alloc] init];
    _loadingAlert.title = @"Please wait";
    _loadingAlert.message = [NSString stringWithFormat:@"Sharing your location with %@...", _name];
    [_loadingAlert show];
    [self performSelector:@selector(sendPing) withObject:nil afterDelay:0.8];
}

- (void)sendPing {
    CLLocationManager* lm = [[CLLocationManager alloc] init];
    [LocationPostmaster shareLocation:lm.location toUserIds:@[_identifier] completion:^(BOOL success) {
        [_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        if (success) {
            UIBAlertView* successAlert = [[UIBAlertView alloc] initWithTitle:@"Success" message:@"Location has been shared successfully." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [successAlert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't share location." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MKMapView* mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.centerCoordinate = _location;
    MapAnnotation* annotation = [[MapAnnotation alloc] initWithCoordinate:_location title:_name];
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:YES];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_location, 1200, 1200);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:mapView];
}

@end
