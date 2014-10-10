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

#import "NSError+FBError.h"

#import "FBError.h"
#import "FBErrorUtility.h"

@implementation NSError (FBError)

- (FBErrorCategory)fberrorCategory {
    return [FBErrorUtility errorCategoryForError:self];
}

- (NSString *)fberrorUserMessage {
    return [FBErrorUtility userMessageForError:self];
}

- (BOOL)fberrorShouldNotifyUser {
    return [FBErrorUtility shouldNotifyUserForError:self];
}

- (NSString *)fberrorUserTitle {
    return [FBErrorUtility userTitleForError:self];
}

- (BOOL)fberrorIsTransient {
    return [FBErrorUtility isTransientError:self];
}

@end
