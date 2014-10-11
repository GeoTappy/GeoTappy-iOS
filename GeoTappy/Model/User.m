//
//  User.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.profileImage = [aDecoder decodeObjectForKey:@"profileImage"];
        self.coverImage = [aDecoder decodeObjectForKey:@"coverImage"];
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.profileImage forKey:@"profileImage"];
    [aCoder encodeObject:self.coverImage forKey:@"coverImage"];
    [aCoder encodeObject:self.friends forKey:@"friends"];
}

@end
