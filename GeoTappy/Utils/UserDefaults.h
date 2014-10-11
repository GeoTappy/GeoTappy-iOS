//
//  UserDefaults.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserDefaults : NSObject

@property (nonatomic) User* currentUser;
@property (nonatomic) NSString* pushToken;

+ (UserDefaults *)instance;
- (void)reset;

@end
