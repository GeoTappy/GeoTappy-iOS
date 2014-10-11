//
//  SuccessView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "SuccessView.h"

@implementation SuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView* tick = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 10, self.frame.size.height / 2 - 10, 20, 20)];
        tick.image = [[UIImage imageNamed:@"tick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        tick.tintColor = [UIColor whiteColor];
        [self addSubview:tick];
        self.backgroundColor = [UIColor colorWithRed:0.47 green:0.80 blue:0.12 alpha:1.00];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
    return self;
}

@end
