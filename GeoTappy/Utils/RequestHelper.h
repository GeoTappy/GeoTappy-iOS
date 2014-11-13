//
//  RequestHelper.h
//  GeoTappy
//
//  Created by Dylan Marriott on 11/10/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestHelperCompletionBlock)(BOOL);
typedef void (^RequestHelperCompletionBlockWithData)(BOOL, NSData *);

@interface RequestHelper : NSObject

+ (NSMutableDictionary *)emptyJsonRequest;
+ (void)startRequest:(NSMutableURLRequest *)request completion:(RequestHelperCompletionBlockWithData)completion;
+ (void)createAccessTokenWithCompletion:(RequestHelperCompletionBlock)completion;

@end
