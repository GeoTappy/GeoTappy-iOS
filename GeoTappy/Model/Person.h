//
//  Person.h
//  GeoTappy
//
//  Created by Dylan Marriott on 14.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"

@interface Person : NSObject <Favourite, NSCoding>

@property (nonatomic) NSNumber* identifier;
@property (nonatomic) NSString* name;
@property (nonatomic) UIImage* profileImage;
@property (nonatomic) NSString* profileImageUrl;
@property (nonatomic) UIImage* coverImage;
@property (nonatomic) NSString* coverImageUrl;

- (void)downloadImages;
- (void)notifyListeners;

@end
