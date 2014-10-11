//
//  HorizontalScroller.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "HorizontalScroller.h"

@implementation HorizontalScroller {
    NSArray* _views;
}

- (id)initWithViews:(NSArray *)views {
    if (self = [super init]) {
        _views = views;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat x = 0;
    int i = 0;
    while (x < self.view.bounds.size.width - 30 && i < _views.count) {
        UIView* v = [_views objectAtIndex:i];
        v.frame = CGRectMake(x, 0, v.frame.size.width, v.frame.size.height);
        [self.view addSubview:v];
        x += v.frame.size.width + self.padding.horizontal;
        i++;
    }
}

@end
