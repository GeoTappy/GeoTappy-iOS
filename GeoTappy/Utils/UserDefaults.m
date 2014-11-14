//
//  UserDefaults.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "UserDefaults.h"
#import "User.h"
#import "Authentication.h"

static User* _currentUser;
static Authentication* _authentication;


@implementation UserDefaults {
    NSUserDefaults* _defaults;
}

static UserDefaults* sharedInstance;

+ (void)initialize {
    [super initialize];
    sharedInstance = [[UserDefaults alloc] init];
}

+ (UserDefaults *)instance {
    return sharedInstance;
}

+ (void)emptyCache {
    _currentUser = nil;
    _authentication = nil;
}

- (id)init {
    if (self = [super init]) {
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.geotappy"];
    }
    return self;
}

#pragma mark - Public
- (User *)currentUser {
    if (_currentUser == nil) {
        _currentUser = (User *)[self codableObjectForKey:@"currentUser"];
    }
    return _currentUser;
}

- (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    [self setCodableObject:currentUser forKey:@"currentUser"];
}

- (Authentication *)authentication {
    if (_authentication == nil) {
        _authentication = (Authentication *)[self codableObjectForKey:@"authentication"];
    }
    return _authentication;
}

- (void)setAuthentication:(Authentication *)authentication {
    _authentication = authentication;
    [self setCodableObject:authentication forKey:@"authentication"];
}

- (NSString *)pushToken {
    return (NSString *)[_defaults objectForKey:@"pushToken"];
}

- (void)setPushToken:(NSString *)pushToken {
    [_defaults setObject:pushToken forKey:@"pushToken"];
    [_defaults synchronize];
}

#pragma mark -
- (void)reset {
    NSString* domain = [[NSBundle mainBundle] bundleIdentifier];
    [_defaults removePersistentDomainForName:domain];
}

#pragma mark - Private
- (void)setCodableObject:(id<NSCoding>)object forKey:(NSString *)key {
    NSData* encoded = [NSKeyedArchiver archivedDataWithRootObject:object];
    [_defaults setObject:encoded forKey:key];
    [_defaults synchronize];
}

- (id<NSCoding>)codableObjectForKey:(NSString *)key {
    NSData* encoded = [_defaults objectForKey:key];
    id<NSCoding> ret = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
    return ret;
}

@end
