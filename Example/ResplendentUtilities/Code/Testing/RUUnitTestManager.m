//
//  RUUnitTestManager.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 4/13/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUUnitTestManager.h"
#import "RUSynthesizeUserDefaultMethods_Testing.h"

#import "RUConstants.h"
#import "RUConditionalReturn.h"
#import "RUOrderedMutableDictionary.h"
#import "RUOrderedDictionary.h"
#import "UIGeometry+RUUtility.h"
#import "NSDictionary+RUReverse.h"





@interface RUUnitTestManager ()

#pragma mark - test_RUOrderedMutableDictionary
+(void)test_RUOrderedMutableDictionary;

#pragma mark - test_RUOrderedDictionary
+(void)test_RUOrderedDictionary;

#pragma mark - Test UIGeometry+RUUtility
+(void)test_UIGeometry_RUUtility;

#pragma mark - Test NSDictionary+RUReverse
+(void)test_NSDictionary_RUReverse;

#pragma mark - Test NSDictionary+RUReverse and RUOrderedDictionary
+(void)test_NSDictionary_RUReverse_and_RUOrderedDictionary;

@end





@implementation RUUnitTestManager

#pragma mark - Run Unit Test
+(void)runUnitTests
{
	[self test_RUOrderedMutableDictionary];
	
	[self test_RUOrderedDictionary];
	
	[self test_UIGeometry_RUUtility];
	
	[self test_NSDictionary_RUReverse];

	[self test_NSDictionary_RUReverse_and_RUOrderedDictionary];
	
	[RUSynthesizeUserDefaultMethods_Testing runTests];
}

#pragma mark - test_RUOrderedMutableDictionary
+(void)test_RUOrderedMutableDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedMutableDictionary class];
}

#pragma mark - test_RUOrderedDictionary
+(void)test_RUOrderedDictionary
{
	/*
	 RUOrderedMutableDictionary validates itself in its `+initialize` method, so we are just calling the class method `class` to trigger it.
	 */
	
	[RUOrderedDictionary class];
}

#pragma mark - test_RUOrderedDictionary
+(void)test_UIGeometry_RUUtility
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
+(void)test_NSDictionary_RUReverse
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
+(void)test_NSDictionary_RUReverse_and_RUOrderedDictionary
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
		NSAssert([[testDictionary_reversed.allValues objectAtIndex:index]isEqualToString:string], @"testDictionary_reversed %@ should have string %@ at index %lu",testDictionary_reversed,string,index);

		NSNumber* number = [testDictionary.allValues objectAtIndex:index];
		NSAssert([[testDictionary_reversed.allKeys objectAtIndex:index]isEqualToNumber:number], @"testDictionary_reversed %@ should have number %@ at index %lu",testDictionary_reversed,number,index);
	}
}

@end
