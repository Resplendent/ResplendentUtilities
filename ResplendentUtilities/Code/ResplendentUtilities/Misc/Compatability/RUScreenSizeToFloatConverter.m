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
		_amountFor480Height = amountFor480Height;
		_amountFor568Height = amountFor568Height;
	}

	return self;
}

@end
