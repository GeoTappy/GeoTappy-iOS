//
//  HorizontalScroller.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HorizontalScroller : UIViewController

@property (nonatomic) UIOffset padding;

- initWithViews:(NSArray *)views;

@end
