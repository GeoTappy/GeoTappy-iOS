//
//  Favourite.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

@protocol FavouriteListener;

@protocol Favourite <NSObject>

- (NSString *)displayName;
- (NSString *)shortDisplayName;
- (void)addFavouriteListener:(id<FavouriteListener>)favourite;

@end
