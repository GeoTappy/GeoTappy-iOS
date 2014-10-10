/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <Foundation/Foundation.h>

@class FBURLConnection;
typedef void (^FBURLConnectionHandler)(FBURLConnection *connection,
                                       NSError *error,
                                       NSURLResponse *response,
                                       NSData *responseData);

@protocol FBURLConnectionDelegate <NSObject>

@optional

- (void)facebookURLConnection:(FBURLConnection *)connection
              didSendBodyData:(NSInteger)bytesWritten
            totalBytesWritten:(NSInteger)totalBytesWritten
    totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end

@interface FBURLConnection : NSObject

- (FBURLConnection *)initWithURL:(NSURL *)url
               completionHandler:(FBURLConnectionHandler)handler;

- (FBURLConnection *)initWithRequest:(NSURLRequest *)request
               skipRoundTripIfCached:(BOOL)skipRoundtripIfCached
                   completionHandler:(FBURLConnectionHandler)handler;

@property (nonatomic, assign) id<FBURLConnectionDelegate> delegate;

- (void)cancel;

@end
