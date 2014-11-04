//
//  Authentication.h
//  GeoTappy
//
//  Created by Dylan Marriott on 28/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authentication : NSObject <NSCoding>

@property (nonatomic) NSString* accessToken;
@property (nonatomic) NSString* refreshToken;
@property (nonatomic) NSDate* expiration;

@end
