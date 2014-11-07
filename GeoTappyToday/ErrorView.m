//
//  ErrorView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 06/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView* cross = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 10, self.frame.size.height / 2 - 10, 20, 20)];
        cross.image = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cross.tintColor = [UIColor whiteColor];
        [self addSubview:cross];
        self.backgroundColor = [UIColor colorWithRed:0.64 green:0.00 blue:0.00 alpha:1.00];
        self.clipsToBounds = YES;
    }
    return self;
}

@end
