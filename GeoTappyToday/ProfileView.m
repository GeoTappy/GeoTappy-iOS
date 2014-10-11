//
//  ProfileView.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "ProfileView.h"
#import <QuartzCore/QuartzCore.h>
#import "SuccessView.h"

@implementation ProfileView {
    NSArray* _images;
    SuccessView* _successView;
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
    
    _successView = [[SuccessView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _successView.alpha = 0;
    [self addSubview:_successView];
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    self.layer.borderWidth = 2;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self animateLoading];
    } else {
        [self.layer removeAllAnimations];
        self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        self.layer.borderWidth = 2;
    }
}

- (void)animateLoading {
    CABasicAnimation* color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    color.fromValue = (id)[UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    color.toValue   = (id)[UIColor colorWithRed:0.20 green:0.58 blue:0.82 alpha:1.00].CGColor;
    self.layer.borderColor = [UIColor colorWithRed:0.20 green:0.58 blue:0.82 alpha:1.00].CGColor;
    
    CABasicAnimation* width = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    width.fromValue = @2;
    width.toValue   = @3;
    self.layer.borderWidth = 2;
    
    CAAnimationGroup* both = [CAAnimationGroup animation];
    both.duration   = 0.8;
    both.animations = @[color, width];
    both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    both.repeatCount = HUGE_VALF;
    both.autoreverses = YES;
    
    [self.layer addAnimation:both forKey:@"color and width"];
}

- (void)showSuccess {
    _successView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^() {
        _successView.transform = CGAffineTransformIdentity;
        _successView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:1.0 options:0 animations:^() {
            _successView.alpha = 0.0;
        } completion:nil];
    }];
}

@end
