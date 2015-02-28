//
//  RUScreenSizeToFloatConverter.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/4/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUScreenSizeToFloatConverter.h"





@interface RUScreenSizeToFloatConverter ()

@property (nonatomic, readonly) NSMutableDictionary* screenHeightMappingMutable;

@end





@implementation RUScreenSizeToFloatConverter

#pragma mark - Init
-(instancetype)initWithAmountFor480Height:(CGFloat)amountFor480Height amountFor568Height:(CGFloat)amountFor568Height
{
	if (self = [super init])
	{
		_screenHeightMappingMutable = [NSMutableDictionary dictionaryWithDictionary:@{
																					  @(480.0f)	: @(amountFor480Height),
																					  @(568.0f)	: @(amountFor568Height),
																					  }];
	}

	return self;
}

-(instancetype)initWithAmountFor480Height:(CGFloat)amountFor480Height amountFor568Height:(CGFloat)amountFor568Height amountFor667Height:(CGFloat)amountFor667Height amountFor736Height:(CGFloat)amountFor736Height
{
	if (self = [self initWithAmountFor480Height:amountFor480Height amountFor568Height:amountFor568Height])
	{
		[self.screenHeightMappingMutable setObject:@(amountFor667Height) forKey:@(667.0f)];
		[self.screenHeightMappingMutable setObject:@(amountFor736Height) forKey:@(736.0f)];
	}

	return self;
}

#pragma mark - appropriateHeightForCurrentScreenHeight
-(CGFloat)appropriateHeightForCurrentScreenHeight
{
	NSNumber* appropriateHeightNumber = [self.screenHeightMapping objectForKey:@(CGRectGetHeight([UIScreen mainScreen].bounds))];
	if (appropriateHeightNumber == nil)
	{
		NSAssert(false, @"unhandled");
		appropriateHeightNumber = [self.screenHeightMapping objectForKey:@(568.0f)];
	}

	return appropriateHeightNumber.floatValue;
}

#pragma mark - screenHeightMapping
-(NSDictionary *)screenHeightMapping
{
	return [self.screenHeightMappingMutable copy];
}

@end
