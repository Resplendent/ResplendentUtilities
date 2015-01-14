//
//  RUPerformOperationToCompletionManager.m
//  Nifti
//
//  Created by Benjamin Maer on 12/13/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "RUPerformOperationToCompletionManager.h"
#import "NSObject+NT_FXReachabilityNotifications.h"

#import "RUSingleton.h"
#import "RUConditionalReturn.h"
#import "RUProtocolOrNil.h"
#import <FXReachability.h>





@interface RUPerformOperationToCompletionManager ()

@property (nonatomic, readonly) NSMutableArray* operationsToRetry;
-(void)addOperationToRetry:(id<RUPerformOperationToCompletionManagerOperation>)operation;
-(void)retryOperationsToRetry;

-(void)notificationDidFire_FXReachability_StatusDidChange;

@end





@implementation RUPerformOperationToCompletionManager

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		_operationsToRetry = [NSMutableArray new];

		[self setRegisteredForNotificationsNT_FXReachability_StatusDidChangeOnWithNotificationSelector:@selector(notificationDidFire_FXReachability_StatusDidChange)];
	}

	return self;
}

-(void)dealloc
{
	[self clearRegisteredForNotificationsNT_FXReachability_StatusDidChange];
}

#pragma mark - Add Operation
-(void)addOperationToBePerformedToCompletion:(id<RUPerformOperationToCompletionManagerOperation>)operation
{
	kRUConditionalReturn(operation == nil, YES);
	kRUConditionalReturn(kRUProtocolOrNil(operation, RUPerformOperationToCompletionManagerOperation) == nil, YES);

	dispatch_async(dispatch_get_main_queue(), ^{

		[operation ru_performOperationToCompletion:^(BOOL didFinishSuccessfully) {
			
			if (didFinishSuccessfully == false)
			{
				[self addOperationToRetry:operation];
			}
			
		}];

	});
}

#pragma mark - Retry
-(void)addOperationToRetry:(id<RUPerformOperationToCompletionManagerOperation>)operation
{
	dispatch_async(dispatch_get_main_queue(), ^{

		[self.operationsToRetry addObject:operation];
		
	});
}

-(void)retryOperationsToRetry
{
	dispatch_async(dispatch_get_main_queue(), ^{

		NSArray* operationsToRetry = [self.operationsToRetry copy];
		[self.operationsToRetry removeAllObjects];

		for (id<RUPerformOperationToCompletionManagerOperation> operationToRetry in operationsToRetry)
		{
			[self addOperationToBePerformedToCompletion:operationToRetry];
		}
		
	});
}

#pragma mark - NSNotificationCenter
-(void)notificationDidFire_FXReachability_StatusDidChange
{
	if ([FXReachability isReachable])
	{
		[self retryOperationsToRetry];
	}
}

#pragma mark - Singleton
RUSingletonUtil_Synthesize_Singleton_Implementation_SharedInstance;

@end
