//
//  Group.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "Group.h"
#import "UserDefaults.h"
#import <DMListener/DMListeners.h>
#import "FavouriteListener.h"

@implementation Group {
    DMListeners* _listeners;
    NSMutableArray* _friends;
}

- (instancetype)init {
    if (self = [super init]) {
        _listeners = [[DMListeners alloc] init];
        _friends = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        _friends = [aDecoder decodeObjectForKey:@"friends"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:_friends forKey:@"friends"];
}

- (NSString *)displayName {
    return self.name;
}

- (NSString *)shortDisplayName {
    return self.name;
}

- (void)addFavouriteListener:(id<Favourite>)favourite {
    [_listeners addListener:favourite];
}

- (NSArray *)friends {
    return _friends;
}

- (void)addFriend:(Friend *)friend {
    [_friends addObject:friend];
    [self notifyListeners];
}

- (void)removeFriend:(id)friend {
    [_friends removeObject:friend];
    [self notifyListeners];
}

- (void)removeFriendAtIndex:(NSUInteger)index {
    [_friends removeObjectAtIndex:index];
    [self notifyListeners];
}

- (void)notifyListeners {
    [_listeners notifyListeners:^(id<FavouriteListener> listener) {
        [listener favouriteChanged:self];
    }];
}

@end
