//
//  Group.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"

@class User;

@interface Group : NSObject <NSCoding, Favourite>

@property (nonatomic) NSString* name;

- (NSArray *)users;
- (void)addUser:(User *)user;
- (void)removeUser:(User *)user;
- (void)removeUserAtIndex:(NSUInteger)index;

@end
