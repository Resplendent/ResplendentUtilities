//
//  NSArray+RUComponents.m
//  Camerama
//
//  Created by Benjamin Maer on 10/18/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "NSArray+RUComponents.h"





@implementation NSArray (RUComponents)

-(NSString*)ru_stringFromPathComponents
{
	NSString* ru_stringFromPathComponents = @"";
	for (NSString* component in self)
	{
		ru_stringFromPathComponents = [ru_stringFromPathComponents stringByAppendingPathComponent:component];
	}

	return ru_stringFromPathComponents;
}

@end
