//
//  UserDefaults.m
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "UserDefaults.h"
#import "User.h"

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

- (id)init {
    if (self = [super init]) {
        _defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.geotappy"];
    }
    return self;
}

#pragma mark - Public
- (User *)currentUser {
    return (User *)[self codableObjectForKey:@"currentUser"];
}

- (void)setCurrentUser:(User *)currentUser {
    [self setCodableObject:currentUser forKey:@"currentUser"];
}

- (NSString *)pushToken {
    return (NSString *)[self codableObjectForKey:@"pushToken"];
}

- (void)setPushToken:(NSString *)pushToken {
    [self setCodableObject:pushToken forKey:@"pushToken"];
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
