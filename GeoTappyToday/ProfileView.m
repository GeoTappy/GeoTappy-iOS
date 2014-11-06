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
#import "ErrorView.h"
#import "ProfileImageView.h"

@implementation ProfileView {
    NSArray* _images;
    SuccessView* _successView;
    ErrorView* _errorView;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images {
    if (self = [super initWithFrame:frame]) {
        _images = images;
        [self assembleViews];
    }
    return self;
}

- (void)assembleViews {
    ProfileImageView* profileImageView = [[ProfileImageView alloc] initWithFrame:self.bounds images:_images];
    [self addSubview:profileImageView];
    
    _successView = [[SuccessView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _successView.alpha = 0;
    [self addSubview:_successView];
    
    _errorView = [[ErrorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _errorView.alpha = 0;
    [self addSubview:_errorView];
    
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

- (void)showError {
    _errorView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^() {
        _errorView.transform = CGAffineTransformIdentity;
        _errorView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:1.0 options:0 animations:^() {
            _errorView.alpha = 0.0;
        } completion:nil];
    }];
}

@end
