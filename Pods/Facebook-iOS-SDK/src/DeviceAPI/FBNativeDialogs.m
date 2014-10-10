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

#import "FBNativeDialogs.h"

#import <Social/Social.h>

#import "FBAccessTokenData+Internal.h"
#import "FBAccessTokenData.h"
#import "FBAppBridge.h"
#import "FBAppCall+Internal.h"
#import "FBAppEvents+Internal.h"
#import "FBAppLinkData+Internal.h"
#import "FBDialogs+Internal.h"
#import "FBDialogsData+Internal.h"
#import "FBDialogsParams+Internal.h"
#import "FBError.h"
#import "FBOpenGraphActionShareDialogParams.h"
#import "FBSession.h"
#import "FBShareDialogParams.h"
#import "FBUtility.h"

@implementation FBNativeDialogs

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (FBOSIntegratedShareDialogHandler)handlerFromHandler:(FBShareDialogHandler)handler {
    if (handler) {
        FBOSIntegratedShareDialogHandler fancy = ^(FBOSIntegratedShareDialogResult result, NSError *error) {
            handler((FBNativeDialogResult)result, error);
        };
        return [[fancy copy] autorelease];
    }
    return nil;
}
#pragma GCC diagnostic pop

+ (BOOL)presentShareDialogModallyFrom:(UIViewController *)viewController
                          initialText:(NSString *)initialText
                                image:(UIImage *)image
                                  url:(NSURL *)url
                              handler:(FBShareDialogHandler)handler {
    return [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController
                                                    initialText:initialText
                                                          image:image
                                                            url:url
                                                        handler:[FBNativeDialogs handlerFromHandler:handler]];
}

+ (BOOL)presentShareDialogModallyFrom:(UIViewController *)viewController
                          initialText:(NSString *)initialText
                               images:(NSArray *)images
                                 urls:(NSArray *)urls
                              handler:(FBShareDialogHandler)handler {
    return [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController
                                                    initialText:initialText
                                                         images:images
                                                           urls:urls
                                                        handler:[FBNativeDialogs handlerFromHandler:handler]];
}

+ (BOOL)presentShareDialogModallyFrom:(UIViewController *)viewController
                              session:(FBSession *)session
                          initialText:(NSString *)initialText
                               images:(NSArray *)images
                                 urls:(NSArray *)urls
                              handler:(FBShareDialogHandler)handler {
    return [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController
                                                        session:session
                                                    initialText:initialText
                                                         images:images
                                                           urls:urls
                                                        handler:[FBNativeDialogs handlerFromHandler:handler]];
}

+ (BOOL)canPresentShareDialogWithSession:(FBSession *)session {
    return [FBDialogs canPresentOSIntegratedShareDialogWithSession:session];
}

@end
