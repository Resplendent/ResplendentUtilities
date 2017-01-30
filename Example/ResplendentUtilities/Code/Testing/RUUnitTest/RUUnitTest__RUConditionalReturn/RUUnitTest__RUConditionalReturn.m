//
//  RUUnitTest__RUConditionalReturn.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 1/30/17.
//  Copyright © 2017 Resplendent. All rights reserved.
//

#import "RUUnitTest__RUConditionalReturn.h"

#import "RUConditionalReturn.h"
#import "RUDLog.h"
#import "RUConstants.h"





@interface RUUnitTest__RUConditionalReturn ()

#pragma mark - RUConditionalReturn
-(void)RUConditionalReturn_unitTest_NO_NO;
-(void)RUConditionalReturn_unitTest_YES_NO;

#pragma mark - errorMessage
@property (nonatomic, copy, nullable) NSString* errorMessage;

@end





@implementation RUUnitTest__RUConditionalReturn

#pragma mark - RUConditionalReturn
-(void)RUConditionalReturn_unitTest_NO_NO
{
	[self setErrorMessage:RUStringWithFormat(kRUDLogStringFormatDeclaration(@"Should not have returned."))];
	
	kRUConditionalReturn(NO, NO);

	[self setErrorMessage:nil];
}

-(void)RUConditionalReturn_unitTest_YES_NO
{
	kRUConditionalReturn(YES, NO);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
	[self setErrorMessage:RUStringWithFormat(kRUDLogStringFormatDeclaration(@"Should have returned."))];
#pragma clang diagnostic pop
}

-(void)RUConditionalReturn_unitTest_NO_YES
{
	[self setErrorMessage:RUStringWithFormat(kRUDLogStringFormatDeclaration(@"Should not have returned."))];
	
	kRUConditionalReturn(NO, NO);
	
	[self setErrorMessage:nil];
}

-(void)RUConditionalReturn_unitTest_YES_YES
{
	[self setErrorMessage:RUStringWithFormat(kRUDLogStringFormatDeclaration(@"Should not have returned, since crash is first getting hit."))];

	BOOL crashed = NO;
	@try {

		RUDLog(@"* Can ignore the upcoming crash, it's intentional and handled");
		kRUConditionalReturn(YES, YES);

	} @catch (NSException *exception) {

		crashed = YES;

	} @finally {

		[self setErrorMessage:
		 (
		  crashed == YES
		  ?
		  nil
		  :
		  RUStringWithFormat(kRUDLogStringFormatDeclaration(@"Should have crashed."))
		  )
		 ];
	}
}

#pragma mark - RUUnitTest
-(nullable NSString*)ru_runUnitTest
{
	[self setErrorMessage:nil];

	NSMutableArray<void (^)()>* unitTestBlocks_checkErrorMessageAfterEach = [NSMutableArray<void(^)()> array];

	/*
	 Add tests
	 */
	[unitTestBlocks_checkErrorMessageAfterEach addObject:^void{
		[self RUConditionalReturn_unitTest_NO_NO];
	}];

	[unitTestBlocks_checkErrorMessageAfterEach addObject:^void{
		[self RUConditionalReturn_unitTest_YES_NO];
	}];

	[unitTestBlocks_checkErrorMessageAfterEach addObject:^void{
		[self RUConditionalReturn_unitTest_NO_YES];
	}];

	[unitTestBlocks_checkErrorMessageAfterEach addObject:^void{
		[self RUConditionalReturn_unitTest_YES_YES];
	}];

	/*
	 Perform tests
	 */
	[unitTestBlocks_checkErrorMessageAfterEach enumerateObjectsUsingBlock:^(void (^ _Nonnull unitTestBlock)(), NSUInteger idx, BOOL * _Nonnull stop) {
		NSAssert(self.errorMessage == nil, @"Should be entering each test with a null error message.");

		unitTestBlock();

		if (self.errorMessage != nil)
		{
			*stop = YES;
		}
	}];

	return self.errorMessage;
}

@end
