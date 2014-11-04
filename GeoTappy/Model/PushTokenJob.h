//
//  PushTokenJob.h
//  GeoTappy
//
//  Created by Dylan Marriott on 03/11/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DMJobManager/DMJobManager.h>

@interface PushTokenJob : NSObject <DMJob>

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithToken:(NSString *)token;

@end
