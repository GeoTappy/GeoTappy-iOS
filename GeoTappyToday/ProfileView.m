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
    UIImageView* _imageView;
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
    _imageView = [[UIImageView alloc] initWithImage:[_images firstObject]];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = self.frame.size.width / 2;
    _imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    _imageView.layer.borderWidth = 2;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    
    _successView = [[SuccessView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _successView.alpha = 0;
    [self addSubview:_successView];
}

- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self animateLoading];
    } else {
        [_imageView.layer removeAllAnimations];
        _imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        _imageView.layer.borderWidth = 2;
    }
}

- (void)animateLoading {
    CABasicAnimation* color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    color.fromValue = (id)[UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    color.toValue   = (id)[UIColor colorWithRed:0.20 green:0.58 blue:0.82 alpha:1.00].CGColor;
    _imageView.layer.backgroundColor = [UIColor colorWithRed:0.20 green:0.58 blue:0.82 alpha:1.00].CGColor;
    
    CABasicAnimation* width = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    width.fromValue = @2;
    width.toValue   = @3;
    _imageView.layer.borderWidth = 2;
    
    CAAnimationGroup *both = [CAAnimationGroup animation];
    both.duration   = 0.8;
    both.animations = @[color, width];
    both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    both.repeatCount = HUGE_VALF;
    both.autoreverses = YES;
    
    [_imageView.layer addAnimation:both forKey:@"color and width"];
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
