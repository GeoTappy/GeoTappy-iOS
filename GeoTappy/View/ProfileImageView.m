//
//  ProfileImageView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 22/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ProfileImageView.h"

@implementation ProfileImageView {
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
    // this is cool code, not
    CGFloat padding = 1;
    if (_images.count == 1) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[_images firstObject]];
        imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    } else if (_images.count == 2) {
        UIImageView* left = [[UIImageView alloc] initWithImage:[_images objectAtIndex:0]];
        left.frame = CGRectMake(0, 0, self.frame.size.width / 2 - padding, self.frame.size.height);
        left.contentMode = UIViewContentModeScaleAspectFill;
        left.clipsToBounds = YES;
        [self addSubview:left];
        
        UIImageView* right = [[UIImageView alloc] initWithImage:[_images objectAtIndex:1]];
        right.frame = CGRectMake(self.frame.size.width / 2 + padding, 0, self.frame.size.width / 2, self.frame.size.height);
        right.contentMode = UIViewContentModeScaleAspectFill;
        right.clipsToBounds = YES;
        [self addSubview:right];
    } else if (_images.count == 3) {
        UIImageView* left = [[UIImageView alloc] initWithImage:[_images objectAtIndex:0]];
        left.frame = CGRectMake(0, 0, self.frame.size.width / 2 - padding, self.frame.size.height);
        left.contentMode = UIViewContentModeScaleAspectFill;
        left.clipsToBounds = YES;
        [self addSubview:left];
        
        UIImageView* rightTop = [[UIImageView alloc] initWithImage:[_images objectAtIndex:1]];
        rightTop.frame = CGRectMake(self.frame.size.width / 2 + padding, 0, self.frame.size.width / 2, self.frame.size.height / 2 - padding);
        rightTop.contentMode = UIViewContentModeScaleAspectFill;
        rightTop.clipsToBounds = YES;
        [self addSubview:rightTop];
        
        UIImageView* rightBottom = [[UIImageView alloc] initWithImage:[_images objectAtIndex:2]];
        rightBottom.frame = CGRectMake(self.frame.size.width / 2 + padding, self.frame.size.height / 2 + padding, self.frame.size.width / 2, self.frame.size.height / 2);
        rightBottom.contentMode = UIViewContentModeScaleAspectFill;
        rightBottom.clipsToBounds = YES;
        [self addSubview:rightBottom];
    } else if (_images.count >= 4) {
        UIImageView* leftTop = [[UIImageView alloc] initWithImage:[_images objectAtIndex:0]];
        leftTop.frame = CGRectMake(0, 0, self.frame.size.width / 2 - padding, self.frame.size.height / 2 - padding);
        leftTop.contentMode = UIViewContentModeScaleAspectFill;
        leftTop.clipsToBounds = YES;
        [self addSubview:leftTop];
        
        UIImageView* leftBottom = [[UIImageView alloc] initWithImage:[_images objectAtIndex:1]];
        leftBottom.frame = CGRectMake(0, self.frame.size.height / 2 + padding, self.frame.size.width / 2 - padding, self.frame.size.height / 2);
        leftBottom.contentMode = UIViewContentModeScaleAspectFill;
        leftBottom.clipsToBounds = YES;
        [self addSubview:leftBottom];
        
        UIImageView* rightTop = [[UIImageView alloc] initWithImage:[_images objectAtIndex:2]];
        rightTop.frame = CGRectMake(self.frame.size.width / 2 + padding, 0, self.frame.size.width / 2, self.frame.size.height / 2 - padding);
        rightTop.contentMode = UIViewContentModeScaleAspectFill;
        rightTop.clipsToBounds = YES;
        [self addSubview:rightTop];
        
        UIImageView* rightBottom = [[UIImageView alloc] initWithImage:[_images objectAtIndex:3]];
        rightBottom.frame = CGRectMake(self.frame.size.width / 2 + padding, self.frame.size.height / 2 + padding, self.frame.size.width / 2, self.frame.size.height / 2);
        rightBottom.contentMode = UIViewContentModeScaleAspectFill;
        rightBottom.clipsToBounds = YES;
        [self addSubview:rightBottom];
    }
}


@end
