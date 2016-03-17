//
//  RUSynthesizeUserDefaultMethods_Testing.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 3/17/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUSynthesizeUserDefaultMethods_Testing.h"

#import <ResplendentUtilities/RUSynthesizeUserDefaultMethods.h>





@interface RUSynthesizeUserDefaultMethods_Testing_TestCase : NSObject

#pragma mark - instanceNumbers
RUSynthesizeSetGetUserDefaultsMethodDeclarations_Instance(InstanceNumbers, instanceNumbers, NSArray<NSNumber*>*);

#pragma mark - generate instanceNumbers
+(NSArray<NSNumber*>*)generate_instanceNumbers;

@end





@implementation RUSynthesizeUserDefaultMethods_Testing_TestCase

#pragma mark - instanceNumbers
RUSynthesizeSetGetUserDefaultsMethod_SynthesizeKey(InstanceNumbers, instanceNumbers, NSArray<NSNumber*>)

#pragma mark - NSObject
-(NSString *)description
{
	NSMutableString* description = [NSMutableString string];

	NSString* description_super = [super description];
	if (description_super)
	{
		[description appendString:description_super];
		[description appendString:@"\n"];
	}

	NSString* instanceNumbers_description = [self.instanceNumbers description];
	if (instanceNumbers_description)
	{
		[description appendString:instanceNumbers_description];
		[description appendString:@"\n"];
	}

	return [description copy];
}

#pragma mark - generate instanceNumbers
+(NSArray<NSNumber*>*)generate_instanceNumbers
{
	NSUInteger const numbers_max = 100;
	NSMutableArray<NSNumber*>* instanceNumbers = [NSMutableArray arrayWithCapacity:numbers_max];

	for (NSUInteger number = 0;
		 number <= numbers_max;
		 number++)
	{
		[instanceNumbers addObject:@(number)];
	}

	return [instanceNumbers copy];
}

@end





@implementation RUSynthesizeUserDefaultMethods_Testing

#pragma mark - Run Tests
+(void)runTests
{
	RUSynthesizeUserDefaultMethods_Testing_TestCase* clearInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	[clearInstanceNumbers setInstanceNumbers:nil];

	NSArray<NSNumber*>* instanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase generate_instanceNumbers];

	RUSynthesizeUserDefaultMethods_Testing_TestCase* setInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	NSAssert(setInstanceNumbers.instanceNumbers == nil, @"setInstanceNumbers %@ should have had nil instanceNumbers",setInstanceNumbers);
	[setInstanceNumbers setInstanceNumbers:instanceNumbers];

	RUSynthesizeUserDefaultMethods_Testing_TestCase* testInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	NSAssert([testInstanceNumbers.instanceNumbers isEqualToArray:instanceNumbers], @"testInstanceNumbers %@ should have had instanceNumbers %@",testInstanceNumbers,instanceNumbers);
}

@end
