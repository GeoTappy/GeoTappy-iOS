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
#import "Group.h"
#import "Friend.h"

@implementation User

- (instancetype)init {
    if (self = [super init]) {
        self.friends = [NSArray array];
        self.selectedFavourites = [NSMutableArray array];
        self.unselectedFavourites = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
        self.selectedFavourites = [aDecoder decodeObjectForKey:@"selectedFavourites"];
        self.unselectedFavourites = [aDecoder decodeObjectForKey:@"unselectedFavourites"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.friends forKey:@"friends"];
    [aCoder encodeObject:self.selectedFavourites forKey:@"selectedFavourites"];
    [aCoder encodeObject:self.unselectedFavourites forKey:@"unselectedFavourites"];
}

- (BOOL)isComplete {
    return self.identifier != nil;
}

- (void)save {
    [UserDefaults instance].currentUser = self;
    [super notifyListeners];
}

- (void)refreshWithCompletion:(UserCompletionBlock)completion {
    NSString* url = [NSString stringWithFormat:@"%@?access_token=%@", [API profileUrl], [UserDefaults instance].authentication.accessToken];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [RequestHelper startRequest:request completion:^(BOOL success, NSData* data) {
        if (success) {
            NSError* jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSDictionary* profile = [json objectForKey:@"profile"];
            
            [self completePerson:self withJson:profile];
            
            NSMutableSet* oldFriends = [NSMutableSet set];
            for (Friend* u in self.friends) {
                [oldFriends addObject:u];
            }
            NSSet* oldFriendsCopy = [NSSet setWithSet:oldFriends];
            NSMutableSet* newFriends = [NSMutableSet set];
            for (NSDictionary* jsonFriend in [profile objectForKey:@"friends"]) {
                Friend* friend = [[Friend alloc] init];
                [self completePerson:friend withJson:jsonFriend];
                [newFriends addObject:friend];
            }
            
            NSMutableSet* sameFriendsOld = [NSMutableSet setWithSet:oldFriends];
            NSMutableSet* sameFriendsNew = [NSMutableSet setWithSet:newFriends];

            [oldFriends minusSet:newFriends];
            [newFriends minusSet:oldFriendsCopy];
            
            [self.selectedFavourites removeObjectsInArray:[oldFriends allObjects]];
            [self.unselectedFavourites removeObjectsInArray:[oldFriends allObjects]];
            
            NSMutableArray* allFavs = [NSMutableArray array];
            [allFavs addObjectsFromArray:self.selectedFavourites];
            [allFavs addObjectsFromArray:self.unselectedFavourites];
            for (id<Favourite> f in allFavs) {
                if ([f isKindOfClass:[Group class]]) {
                    Group* g = (Group *)f;
                    for (int i = 0; i < g.friends.count; i++) {
                        Friend* u = [g.friends objectAtIndex:i];
                        if ([oldFriends containsObject:u]) {
                            [g removeFriendAtIndex:i];
                        }
                    }
                }
            }
    

            [sameFriendsOld minusSet:oldFriends];
            [sameFriendsNew minusSet:newFriends];
            NSAssert(sameFriendsNew.count == sameFriendsOld.count, @"Set count not the same!");
            NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES];
            NSArray* oldSorted = [sameFriendsOld.allObjects sortedArrayUsingDescriptors:@[sort]];
            NSArray* newSorted = [sameFriendsNew.allObjects sortedArrayUsingDescriptors:@[sort]];
            for (int i = 0; i < oldSorted.count; i++) {
                Friend* old = [oldSorted objectAtIndex:i];
                Friend* new = [newSorted objectAtIndex:i];
                NSAssert(old.identifier.intValue == new.identifier.intValue, @"Id not the same!");
                old.name = new.name;
                if (![old.coverImageUrl isEqualToString:new.coverImageUrl]) {
                    old.coverImageUrl = new.coverImageUrl;
                    old.profileImage = nil;
                }
                if (![old.profileImageUrl isEqualToString:new.profileImageUrl]) {
                    old.profileImageUrl = new.profileImageUrl;
                    old.profileImage = nil;
                }
            }
            
            
            self.friends = [self.friends arrayByAddingObjectsFromArray:[newFriends allObjects]];
            for (Friend* f in newFriends) {
                if (self.selectedFavourites.count < 3) {
                    [self.selectedFavourites addObject:f];
                } else {
                    [self.unselectedFavourites addObject:f];
                }
            }
            
            for (Friend* f in self.friends) {
                [f downloadImages];
            }
            [self downloadImages];
            
            
            [self save];
        }
        if (completion) {
            completion();
        }
    }];
}

- (void)completePerson:(Person *)person withJson:(NSDictionary *)json {
    person.coverImageUrl = [json objectForKey:@"cover_photo_url"];
    person.profileImageUrl = [json objectForKey:@"profile_photo_url"];
    person.name = [json objectForKey:@"name"];
    person.identifier = [json objectForKey:@"id"];
}

@end
