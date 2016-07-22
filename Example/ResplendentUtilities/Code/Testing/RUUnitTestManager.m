//
//  RUUnitTestManager.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 4/13/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUUnitTestManager.h"
#import "RUSynthesizeUserDefaultMethods_Testing.h"
#import "RUUnitTest__RUNotifications.h"

#import "RUConstants.h"
#import "RUConditionalReturn.h"
#import "RUOrderedMutableDictionary.h"
#import "RUOrderedDictionary.h"
#import "UIGeometry+RUUtility.h"
#import "NSDictionary+RUReverse.h"
#import "RUEnumIsInRangeSynthesization.h"
#import "RUScreenHeightTypes.h"
#import "NSMutableArray+RUAddObjectIfNotNil.h"





/**
 Don't use these enum types anymore, use `RUUnitTest` instead.
 */
typedef NS_ENUM(NSInteger, RUUnitTestManager__testType) {
	RUUnitTestManager__testType_RUOrderedMutableDictionary,
	RUUnitTestManager__testType_RUOrderedDictionary,
	RUUnitTestManager__testType_UIGeometry_RUUtility,
	RUUnitTestManager__testType_NSDictionary_RUReverse,
	RUUnitTestManager__testType_NSDictionary_RUReverse_and_RUOrderedDictionary,
	RUUnitTestManager__testType_RUSynthesizeUserDefaultMethods,
	RUUnitTestManager__testType_RUScreenHeightTypes,
	
	RUUnitTestManager__testType__first	= RUUnitTestManager__testType_RUOrderedMutableDictionary,
	RUUnitTestManager__testType__last	= RUUnitTestManager__testType_RUScreenHeightTypes,
};

RUEnumIsInRangeSynthesization_autoFirstLast(RUUnitTestManager__testType)





@interface RUUnitTestManager ()

#pragma mark - Run Unit Test
-(void)runUnitTest:(RUUnitTestManager__testType)testType;

#pragma mark - test_RUOrderedMutableDictionary
-(void)test_RUOrderedMutableDictionary;

#pragma mark - test_RUOrderedDictionary
-(void)test_RUOrderedDictionary;

#pragma mark - Test UIGeometry+RUUtility
-(void)test_UIGeometry_RUUtility;

#pragma mark - Test NSDictionary+RUReverse
-(void)test_NSDictionary_RUReverse;

#pragma mark - Test NSDictionary+RUReverse and RUOrderedDictionary
-(void)test_NSDictionary_RUReverse_and_RUOrderedDictionary;

#pragma mark - Test RUScreenHeightTypes
-(void)test_RUScreenHeightTypes;
-(CGFloat)test_RUScreenHeightTypes_appropriateHeightForType:(RUScreenHeightType)screenHeightType;

#pragma mark - unitTests
-(nonnull NSArray<id<RUUnitTest>>*)unitTests;

@end





@implementation RUUnitTestManager

#pragma mark - Run Unit Test
+(void)runUnitTests
{
	RUUnitTestManager* const unitTestManager = [RUUnitTestManager new];
	[unitTestManager runUnitTests];
}

-(void)runUnitTests
{
	for (RUUnitTestManager__testType testType = RUUnitTestManager__testType__first;
		 testType <= RUUnitTestManager__testType__last;
		 testType++)
	{
		[self runUnitTest:testType];
	}

	[[self unitTests] enumerateObjectsUsingBlock:^(id<RUUnitTest>  _Nonnull unitTest, NSUInteger idx, BOOL * _Nonnull stop) {

		NSString* const errorMessage = [unitTest ru_runUnitTest];
		NSAssert(errorMessage == nil, errorMessage);

	}];
}

-(void)runUnitTest:(RUUnitTestManager__testType)testType
{
	kRUConditionalReturn(RUUnitTestManager__testType__isInRange(testType) == false, YES);

	switch (testType)
	{
		case RUUnitTestManager__testType_RUOrderedMutableDictionary:
			[self test_RUOrderedMutableDictionary];
			break;

		case RUUnitTestManager__testType_RUOrderedDictionary:
			[self test_RUOrderedDictionary];
			break;
			
		case RUUnitTestManager__testType_UIGeometry_RUUtility:
			[self test_UIGeometry_RUUtility];
			break;
			
		case RUUnitTestManager__testType_NSDictionary_RUReverse:
			[self test_NSDictionary_RUReverse];
			break;
			
		case RUUnitTestManager__testType_NSDictionary_RUReverse_and_RUOrderedDictionary:
			[self test_NSDictionary_RUReverse_and_RUOrderedDictionary];
			break;

		case RUUnitTestManager__testType_RUSynthesizeUserDefaultMethods:
			[RUSynthesizeUserDefaultMethods_Testing runTests];
			break;
			
		case RUUnitTestManager__testType_RUScreenHeightTypes:
			[self test_RUScreenHeightTypes];
			break;
	}
}

#pragma mark - test_RUOrderedMutableDictionary
-(void)test_RUOrderedMutableDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedMutableDictionary class];
}

#pragma mark - test_RUOrderedDictionary
-(void)test_RUOrderedDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedDictionary class];
}

#pragma mark - test_RUOrderedDictionary
-(void)test_UIGeometry_RUUtility
{
	CGFloat const test_1_value = 123.456f;
	UIEdgeInsets const test_1_answer = (UIEdgeInsets){
		.left		= test_1_value,
		.right		= test_1_value,
		.top		= test_1_value,
		.bottom		= test_1_value,
	};
	
	UIEdgeInsets const test_1_attemptedAnswer = RU_UIEdgeInsetsMakeAll(test_1_value);
	NSAssert(UIEdgeInsetsEqualToEdgeInsets(test_1_answer, test_1_attemptedAnswer),
			 @"test_1_attemptedAnswer should have been %@, but instead was %@",NSStringFromUIEdgeInsets(test_1_answer),NSStringFromUIEdgeInsets(test_1_attemptedAnswer));
	
	UIEdgeInsets const test_2_answer = (UIEdgeInsets){
		.left		= -test_1_answer.left,
		.right		= -test_1_answer.right,
		.top		= -test_1_answer.top,
		.bottom		= -test_1_answer.bottom,
	};
	
	UIEdgeInsets test_2_attemptedAnswer = RU_UIEdgeInsetsInvert(test_1_answer);
	NSAssert(UIEdgeInsetsEqualToEdgeInsets(test_2_answer, test_2_attemptedAnswer),
			 @"test_2_attemptedAnswer should have been %@, but instead was %@",NSStringFromUIEdgeInsets(test_2_answer),NSStringFromUIEdgeInsets(test_2_attemptedAnswer));
}

#pragma mark - NSDictionary+RUReverse
-(void)test_NSDictionary_RUReverse
{
	NSDictionary<NSString*,NSNumber*>* testDictionary =
	@{
	  @"One"	: @(1),
	  @"Two"	: @(2),
	  @"Three"	: @(3),
	  };
	
	NSDictionary<NSNumber*,NSString*>* testDictionary_reversed = [testDictionary ru_reverseDictionary];
	
	[testDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
		
		NSAssert([[testDictionary_reversed objectForKey:obj] isEqualToString:key], @"testDictionary_reversed %@ should have object %@ for key %@",testDictionary_reversed,key,obj);
		
	}];
}

#pragma mark - Test NSDictionary+RUReverse and RUOrderedDictionary
-(void)test_NSDictionary_RUReverse_and_RUOrderedDictionary
{
	static NSInteger const lastValue = 100;
	static NSInteger const startValue = -lastValue;
	
	NSMutableArray<NSNumber*>* orderedNumbers_mutable = [NSMutableArray array];
	NSMutableArray<NSString*>* orderedStrings_mutable = [NSMutableArray array];
	
	for (NSInteger i = startValue;
		 i <= lastValue;
		 i++)
	{
		NSNumber* number = @(i);
		[orderedNumbers_mutable addObject:number];
		[orderedStrings_mutable addObject:number.stringValue];
	}
	
	kRUConditionalReturn(orderedNumbers_mutable.count != (1 + lastValue - startValue), YES);
	kRUConditionalReturn(orderedStrings_mutable.count != (1 + lastValue - startValue), YES);
	
	NSArray<NSNumber*>* orderedNumbers = [orderedNumbers_mutable copy];
	NSArray<NSString*>* orderedStrings = [orderedStrings_mutable copy];
	
	// staticConstructor
	RUOrderedDictionary<NSString*,NSNumber*>* testDictionary = [RUOrderedDictionary<NSString*,NSNumber*>
																dictionaryWithObjects:orderedNumbers
																forKeys:orderedStrings];
	kRUConditionalReturn((testDictionary == nil), YES);

	RUOrderedDictionary<NSNumber*,NSString*>* testDictionary_reversed = [testDictionary ru_reverseDictionary];

	for (NSUInteger index = 0;
		 index < testDictionary.count;
		 index++)
	{
		NSString* string = [testDictionary.allKeys objectAtIndex:index];
		NSAssert([[testDictionary_reversed.allValues objectAtIndex:index]isEqualToString:string], @"testDictionary_reversed %@ should have string %@ at index %lu",testDictionary_reversed,string,(unsigned long)index);

		NSNumber* number = [testDictionary.allValues objectAtIndex:index];
		NSAssert([[testDictionary_reversed.allKeys objectAtIndex:index]isEqualToNumber:number], @"testDictionary_reversed %@ should have number %@ at index %lu",testDictionary_reversed,number,(unsigned long)index);
	}
}

#pragma mark - Test RUScreenHeightTypes
-(void)test_RUScreenHeightTypes
{
	RUScreenHeightType const screenHeightType = RUScreenHeightType__forCurrentScreen();
	CGFloat const screenHeightType_appropriateHeight = [self test_RUScreenHeightTypes_appropriateHeightForType:screenHeightType];
	CGFloat const deviceHeight =
	(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ?
	 CGRectGetWidth([UIScreen mainScreen].bounds) :
	 CGRectGetHeight([UIScreen mainScreen].bounds));

	NSAssert(deviceHeight == screenHeightType_appropriateHeight,
			 @"height mismatch for screenHeightType %li",(long)screenHeightType);
}

-(CGFloat)test_RUScreenHeightTypes_appropriateHeightForType:(RUScreenHeightType)screenHeightType
{
	switch (screenHeightType)
	{
		case RUScreenHeightType_unknown:
			break;

		case RUScreenHeightType_480:
			return 480.0f;
			break;

		case RUScreenHeightType_568:
			return 568.0f;
			break;

		case RUScreenHeightType_667:
			return 667.0f;
			break;

		case RUScreenHeightType_736:
			return 736.0f;
			break;

		case RUScreenHeightType_iPad_512:
			return 512.0f;
			break;

		case RUScreenHeightType_iPad_1024:
			return 1024.0f;
			break;

		case RUScreenHeightType_iPad_1366:
			return 1366.0f;
			break;
	}

	NSAssert(false, @"unhandled screenHeightType %li",(long)screenHeightType);
	return 0.0f;
}

#pragma mark - unitTests
-(nonnull NSArray<id<RUUnitTest>>*)unitTests
{
	NSMutableArray<id<RUUnitTest>>* const unitTests = [NSMutableArray<id<RUUnitTest>> array];

	[unitTests ru_addObjectIfNotNil:[RUUnitTest__RUNotifications new]];

	return [NSArray<id<RUUnitTest>> arrayWithArray:unitTests];
}

@end
