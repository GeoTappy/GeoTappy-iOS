//
//  User.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "User.h"
#import "UserDefaults.h"
#import <DMListener/DMListener.h>
#import "FavouriteListener.h"
#import "Authentication.h"
#import "RequestHelper.h"

@implementation User {
    DMListeners* _listeners;
}

- (instancetype)init {
    if (self = [super init]) {
        _listeners = [[DMListeners alloc] init];
        self.selectedFavourites = [NSMutableArray array];
        self.unselectedFavourites = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
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

- (void)addFavouriteListener:(id<Favourite>)favourite {
    [_listeners addListener:favourite];
}

- (BOOL)isComplete {
    return self.identifier != nil;
}

- (void)save {
    [UserDefaults instance].currentUser = self;
    [_listeners notifyListeners:^(id<FavouriteListener> listener) {
        [listener favouriteChanged:self];
    }];
}

- (void)refreshWithCompletion:(UserCompletionBlock)completion {
    NSString* url = [NSString stringWithFormat:@"%@?access_token=%@", [API profileUrl], [UserDefaults instance].authentication.accessToken];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [RequestHelper startRequest:request completion:^(BOOL success, NSData* data) {
        NSError* jsonError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSDictionary* profile = [json objectForKey:@"profile"];
        
        [self completeUser:self withJson:profile];
        
        NSMutableDictionary* oldFriends = [NSMutableDictionary dictionary];
        for (User* u in self.friends) {
            [oldFriends setObject:u forKey:u.identifier];
        }
        
        NSMutableArray* friends = [NSMutableArray array];
        for (NSDictionary* jsonFriend in [profile objectForKey:@"friends"]) {
            User* friend = [oldFriends objectForKey:[jsonFriend objectForKey:@"id"]];
            if (friend == nil) {
                friend = [[User alloc] init];
            }
            [self completeUser:friend withJson:jsonFriend];
            [friends addObject:friend];
        }
        self.friends = [NSArray arrayWithArray:friends];
        
        int i = 0;
        for (User* u in friends) {
            if (i < 3) {
                [self.selectedFavourites addObject:u];
            } else {
                [self.unselectedFavourites addObject:u];
            }
            i++;
        }
        [self save];
        
        completion();
    }];
}

- (void)completeUser:(User *)user withJson:(NSDictionary *)json {
    user.coverImage = [self downloadImage:[json objectForKey:@"cover_photo_url"]];
    user.profileImage = [self downloadImage:[json objectForKey:@"profile_photo_url"]];
    user.name = [json objectForKey:@"name"];
    user.identifier = [json objectForKey:@"id"];
}

- (UIImage *)downloadImage:(NSString *)url {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;
    }
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [[UIImage alloc] initWithData:data];
}

- (BOOL)isEqual:(id)object {
    return self.identifier == ((User *)object).identifier;
}

@end
