//
//  LocationPostmaster.h
//  GeoTappy
//
//  Created by Dylan Marriott on 14.11.14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// Best name ever
@interface LocationPostmaster : NSObject

+ (void)shareLocation:(CLLocation *)location toFriends:(NSArray *)friends completion:(void (^)(BOOL))completion;

@end
