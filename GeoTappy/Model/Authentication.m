//
//  Authentication.m
//  GeoTappy
//
//  Created by Dylan Marriott on 28/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "Authentication.h"

@implementation Authentication

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
        self.expiration = [aDecoder decodeObjectForKey:@"expiration"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [aCoder encodeObject:self.expiration forKey:@"expiration"];
}

@end
