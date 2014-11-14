//
//  UserDefaults.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Authentication;
@class User;

@interface UserDefaults : NSObject

@property (nonatomic) User* currentUser;
@property (nonatomic) Authentication* authentication;
@property (nonatomic) NSString* pushToken;

+ (UserDefaults *)instance;
+ (void)emptyCache; // super ugly code

@end
