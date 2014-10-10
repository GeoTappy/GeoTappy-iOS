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

#import "FBAppLinkData.h"

@interface FBAppLinkData (Internal)

@property (readonly) BOOL isValid;

- (instancetype)initWithURL:(NSURL *)url
                  targetURL:(NSURL *)targetURL
             originalParams:(NSDictionary *)originalQueryParameters
                  arguments:(NSDictionary *)arguments;

- (instancetype)initWithURL:(NSURL *)url
                  targetURL:(NSURL *)targetURL
                        ref:(NSString *)ref
                  userAgent:(NSString *)userAgent
                refererData:(NSDictionary *)refererData
             originalParams:(NSDictionary *)originalQueryParameters;

+ (FBAppLinkData *)createFromURL:(NSURL *)url;

@end
