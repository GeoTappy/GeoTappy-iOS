//
//  User.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic) NSString* name;
@property (nonatomic) UIImage* profileImage;
@property (nonatomic) UIImage* coverImage;

@end
