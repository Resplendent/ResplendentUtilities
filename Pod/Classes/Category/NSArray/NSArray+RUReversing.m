//
//  NSArray+RUReversing.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/16/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "NSArray+RUReversing.h"





@implementation NSArray (RUReversing)

-(NSMutableArray*)ru_reversedArray
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	NSEnumerator *enumerator = [self reverseObjectEnumerator];
	for (id element in enumerator)
	{
		[array addObject:element];
	}
	return array;
}

@end
