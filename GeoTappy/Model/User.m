//
//  User.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "User.h"
#import "UserDefaults.h"

@implementation User

- (instancetype)init {
    if (self = [super init]) {
        self.selectedFavourites = [NSMutableArray array];
        self.unselectedFavourites = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.profileImage = [aDecoder decodeObjectForKey:@"profileImage"];
        self.coverImage = [aDecoder decodeObjectForKey:@"coverImage"];
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
        self.selectedFavourites = [aDecoder decodeObjectForKey:@"selectedFavourites"];
        self.unselectedFavourites = [aDecoder decodeObjectForKey:@"unselectedFavourites"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.profileImage forKey:@"profileImage"];
    [aCoder encodeObject:self.coverImage forKey:@"coverImage"];
    [aCoder encodeObject:self.friends forKey:@"friends"];
    [aCoder encodeObject:self.selectedFavourites forKey:@"selectedFavourites"];
    [aCoder encodeObject:self.unselectedFavourites forKey:@"unselectedFavourites"];
}

- (NSString *)displayName {
    return self.name;
}

- (NSString *)shortDisplayName {
    return [[self.name componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (void)save {
    [UserDefaults instance].currentUser = self;
}

- (BOOL)isEqual:(id)object {
    return self.identifier == ((User *)object).identifier;
}

@end
