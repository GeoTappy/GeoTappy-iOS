//
//  ProfileView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ProfileView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileView {
    NSArray* _images;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images {
    if (self = [super initWithFrame:frame]) {
        _images = images;
        [self assembleViews];
    }
    return self;
}

- (void)assembleViews {
    UIImageView* image = [[UIImageView alloc] initWithImage:[_images firstObject]];
    image.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    image.clipsToBounds = YES;
    image.layer.cornerRadius = self.frame.size.width / 2;
    image.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    image.layer.borderWidth = 2;
    image.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:image];
}

@end
