//
//  NSMutableDictionary+RUUtil.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/29/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSMutableDictionary+RUUtil.h"





@implementation NSMutableDictionary (RUUtil)

-(void)setObjectOrRemoveIfNil:(id)anObject forKey:(id<NSCopying>)aKey
{
	if (anObject == nil)
	{
		[self removeObjectForKey:aKey];
	}
	else
	{
		[self setObject:anObject forKey:aKey];
	}
}

@end
