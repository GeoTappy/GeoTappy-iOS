//
//  User.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"

@interface User : NSObject <NSCoding, Favourite>

@property (nonatomic) NSString* identifier;
@property (nonatomic) NSString* name;
@property (nonatomic) UIImage* profileImage;
@property (nonatomic) UIImage* coverImage;
@property (nonatomic) NSArray* friends; // User
@property (nonatomic) NSArray* favourites; // id<Favourite>

@end
