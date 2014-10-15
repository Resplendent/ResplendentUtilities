//
//  NSMutableArray+RUAddObjectIfNotNil.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 10/14/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSMutableArray+RUAddObjectIfNotNil.h"





@implementation NSMutableArray (RUAddObjectIfNotNil)

-(void)ru_addObjectIfNotNil:(id)object
{
	if (object)
	{
		[self addObject:object];
	}
}

@end
