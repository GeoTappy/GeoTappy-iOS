//
//  FavouriteListener.h
//  GeoTappy
//
//  Created by Dylan Marriott on 05/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

@protocol Favourite;

@protocol FavouriteListener <NSObject>

- (void)favouriteChanged:(id<Favourite>)favourite;

@end
