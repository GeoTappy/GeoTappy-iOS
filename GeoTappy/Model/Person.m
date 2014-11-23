//
//  Person.m
//  GeoTappy
//
//  Created by Dylan Marriott on 14.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "Person.h"
#import <DMListener/DMListener.h>
#import "FavouriteListener.h"

@implementation Person {
    DMListeners* _listeners;
}

- (instancetype)init {
    if (self = [super init]) {
        _listeners = [[DMListeners alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.profileImage = [aDecoder decodeObjectForKey:@"profileImage"];
        self.profileImageUrl = [aDecoder decodeObjectForKey:@"profileImageUrl"];
        self.coverImage = [aDecoder decodeObjectForKey:@"coverImage"];
        self.coverImageUrl = [aDecoder decodeObjectForKey:@"coverImageUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.profileImage forKey:@"profileImage"];
    [aCoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
    [aCoder encodeObject:self.coverImage forKey:@"coverImage"];
    [aCoder encodeObject:self.coverImageUrl forKey:@"coverImageUrl"];
}

- (void)addFavouriteListener:(id<Favourite>)favourite {
    [_listeners addListener:favourite];
}

- (void)notifyListeners {
    [_listeners notifyListeners:^(id<FavouriteListener> listener) {
        [listener favouriteChanged:self];
    }];
}

- (void)downloadImages {
    if (self.profileImage == nil) {
        self.profileImage = [self downloadImage:self.profileImageUrl];
    }
    if (self.coverImage == nil) {
        self.coverImage = [self downloadImage:self.coverImageUrl];
    }
}

- (UIImage *)downloadImage:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [[UIImage alloc] initWithData:data];
}

- (NSString *)displayName {
    return self.name;
}

- (NSString *)shortDisplayName {
    return [[self.name componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Person class]]) {
        return NO;
    }
    return [self.identifier isEqualToNumber:((Person *)object).identifier];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

@end
