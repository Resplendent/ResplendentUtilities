//
//  NSArray+RUShuffling.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/3/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "NSArray+RUShuffling.h"





@implementation NSArray (RUShuffling)

-(NSMutableArray*)ru_shuffledArray
{
	NSMutableArray* shuffledArray = [NSMutableArray arrayWithArray:self];
	NSUInteger count = [self count];
	for (NSUInteger i = 0; i < count; ++i)
	{
		NSInteger remainingCount = count - i;
		NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
		[shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
	}
	return shuffledArray;
}

@end
