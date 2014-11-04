//
//  ProfileImageView.h
//  GeoTappy
//
//  Created by Dylan Marriott on 22/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images; // UIImage
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

@end
