//
//  RUSynthesizeUserDefaultMethods_Testing.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 3/17/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUSynthesizeUserDefaultMethods_Testing.h"

#import <ResplendentUtilities/RUSynthesizeUserDefaultMethods.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@interface RUSynthesizeUserDefaultMethods_Testing_TestCase : NSObject

#pragma mark - instanceNumbers
RUSynthesizeSetGetUserDefaultsMethodDeclarations_Instance(InstanceNumbers, instanceNumbers, NSArray<NSNumber*>*);

#pragma mark - staticNumbers
RUSynthesizeSetGetUserDefaultsMethodDeclarations_Static(StaticNumbers, staticNumbers, NSArray<NSNumber*>*);

#pragma mark - generate instanceNumbers
+(NSArray<NSNumber*>*)generate_instanceNumbers;

@end





@implementation RUSynthesizeUserDefaultMethods_Testing_TestCase

#pragma mark - instanceNumbers
RUSynthesizeSetGetUserDefaultsMethod_SynthesizeKey(InstanceNumbers, instanceNumbers, NSArray<NSNumber*>)

#pragma mark - staticNumbers
RUSynthesizeStaticSetGetUserDefaultsMethod_SynthesizeKey(StaticNumbers, staticNumbers, NSArray<NSNumber*>);

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





@interface RUSynthesizeUserDefaultMethods_Testing ()

#pragma mark - Run Instance Tests
+(void)runInstanceTestsWithInstanceNumbers:(nonnull NSArray<NSNumber*>*)instanceNumbers;

#pragma mark - Run Static Tests
+(void)runStaticTestsWithInstanceNumbers:(nonnull NSArray<NSNumber*>*)instanceNumbers;

@end





@implementation RUSynthesizeUserDefaultMethods_Testing

#pragma mark - Run Tests
+(void)runTests
{
	NSArray<NSNumber*>* instanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase generate_instanceNumbers];

	[self runInstanceTestsWithInstanceNumbers:instanceNumbers];
	[self runStaticTestsWithInstanceNumbers:instanceNumbers];
}

#pragma mark - Run Instance Tests
+(void)runInstanceTestsWithInstanceNumbers:(nonnull NSArray<NSNumber*>*)instanceNumbers
{
	kRUConditionalReturn(instanceNumbers == nil, YES);

	RUSynthesizeUserDefaultMethods_Testing_TestCase* clearInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	[clearInstanceNumbers setInstanceNumbers:nil];
	
	RUSynthesizeUserDefaultMethods_Testing_TestCase* setInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	NSAssert(setInstanceNumbers.instanceNumbers == nil, @"setInstanceNumbers %@ should have had nil instanceNumbers",setInstanceNumbers);
	[setInstanceNumbers setInstanceNumbers:instanceNumbers];
	
	RUSynthesizeUserDefaultMethods_Testing_TestCase* testInstanceNumbers = [RUSynthesizeUserDefaultMethods_Testing_TestCase new];
	NSAssert([testInstanceNumbers.instanceNumbers isEqualToArray:instanceNumbers], @"testInstanceNumbers %@ should have had instanceNumbers %@",testInstanceNumbers,instanceNumbers);
}

#pragma mark - Run Static Tests
+(void)runStaticTestsWithInstanceNumbers:(nonnull NSArray<NSNumber*>*)instanceNumbers
{
	kRUConditionalReturn(instanceNumbers == nil, YES);
	
	[RUSynthesizeUserDefaultMethods_Testing_TestCase setStaticNumbers:nil];
	NSAssert([RUSynthesizeUserDefaultMethods_Testing_TestCase staticNumbers] == nil, @"staticNumbers should be nil, but was %@",[RUSynthesizeUserDefaultMethods_Testing_TestCase staticNumbers]);

	[RUSynthesizeUserDefaultMethods_Testing_TestCase setStaticNumbers:instanceNumbers];
	NSAssert([[RUSynthesizeUserDefaultMethods_Testing_TestCase staticNumbers] isEqualToArray:instanceNumbers], @"staticNumbers %@ should have had instanceNumbers %@",[RUSynthesizeUserDefaultMethods_Testing_TestCase staticNumbers],instanceNumbers);
}

@end
