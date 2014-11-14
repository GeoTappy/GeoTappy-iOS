//
//  User.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Favourite.h"
#import "Person.h"

typedef void (^UserCompletionBlock)();

@interface User : Person <NSCoding>

@property (nonatomic) NSArray* friends; // User
@property (nonatomic) NSMutableArray* selectedFavourites; // id<Favourite>
@property (nonatomic) NSMutableArray* unselectedFavourites; // id<Favourite>

- (BOOL)isComplete;
- (void)save;
- (void)refreshWithCompletion:(UserCompletionBlock)completion;

@end
