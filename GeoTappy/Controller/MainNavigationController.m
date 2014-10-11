//
//  MainNavigationController.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "MainNavigationController.h"
#import "MainViewController.h"

@implementation MainNavigationController

- (instancetype)init {
    if (self = [super init]) {
        MainViewController* vc = [[MainViewController alloc] init];
        [self pushViewController:vc animated:YES];
    }
    return self;
}

@end
