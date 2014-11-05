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
    NSMutableArray* _users;
}

- (instancetype)init {
    if (self = [super init]) {
        _listeners = [[DMListeners alloc] init];
        _users = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        _users = [aDecoder decodeObjectForKey:@"users"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:_users forKey:@"users"];
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

- (NSArray *)users {
    return _users;
}

- (void)addUser:(id)user {
    [_users addObject:user];
    [self notifyListeners];
}

- (void)removeUser:(id)user {
    [_users removeObject:user];
    [self notifyListeners];
}

- (void)removeUserAtIndex:(NSUInteger)index {
    [_users removeObjectAtIndex:index];
    [self notifyListeners];
}

- (void)notifyListeners {
    [_listeners notifyListeners:^(id<FavouriteListener> listener) {
        [listener favouriteChanged:self];
    }];
}

@end
