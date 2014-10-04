//
//  RUScreenSizeToFloatConverter.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/4/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RUScreenSizeToFloatConverter.h"





@implementation RUScreenSizeToFloatConverter

-(instancetype)initWithAmountFor480Height:(CGFloat)amountFor480Height amountFor568Height:(CGFloat)amountFor568Height
{
	if (self = [super init])
	{
		_screenHeightMapping = @{
								 @(480.0f)	: @(amountFor480Height),
								 @(568.0f)	: @(amountFor568Height),
								 };
	}

	return self;
}

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

@end
