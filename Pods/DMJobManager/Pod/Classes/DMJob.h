//
//  DMJob.h
//  Pods
//
//  Created by Dylan Marriott on 03/11/14.
//
//

typedef void (^CompletionBlock)(BOOL);

/**
 *  Defines what a job is.
 */
@protocol DMJob <NSObject, NSCoding>

/**
 *  This method will be called by the JobManager.
 *  Inside here you should execute your desired work.
 *  When done, call the completion block with either YES (success) or NO (fail -> retry)
 *
 *  @param completion completion block
 */
- (void)executeWithCompletion:(CompletionBlock)completion;

@optional

/**
 *  The desired delay until the job will be executed again if it fails .
 *
 *  @return delay in seconds, default is 10
 */
- (NSTimeInterval)retryDelay;

/**
 *  This method will be called before the JobManager executes the job again. Use this if you want to increase the retryDelay according to the number of retries.
 */
- (void)willRetry;

@end
