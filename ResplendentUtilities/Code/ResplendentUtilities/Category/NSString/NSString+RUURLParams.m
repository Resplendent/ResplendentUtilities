//
//  NSString+RUUrlParams.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 8/31/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSString+RUURLParams.h"
#import "NSMutableDictionary+RUUtil.h"
#import "RUClassOrNilUtil.h"





@implementation NSString (RUURLParams)

-(NSDictionary*)ru_URLParams
{
	if (self.length == 0)
	{
		return nil;
	}

	NSArray* urlComponents = [self componentsSeparatedByString:@"&"];
	NSMutableDictionary* ruURLParams = [NSMutableDictionary dictionaryWithCapacity:urlComponents.count];

	for (NSString* urlComponent in urlComponents)
	{
		NSArray* urlComponentsKeyAndValue = [urlComponent componentsSeparatedByString:@"="];
		if (urlComponentsKeyAndValue.count != 2)
		{
			NSAssert(false, @"unhandled");
			continue;
		}

		NSString* key = urlComponentsKeyAndValue.firstObject;
		id value = urlComponentsKeyAndValue.lastObject;
		NSArray* commaSeparatedValue = [value componentsSeparatedByString:@","];

		[ruURLParams setObject:(commaSeparatedValue.count == 1 ? commaSeparatedValue.firstObject : commaSeparatedValue) forKey:key];
	}

	return [ruURLParams copy];
}

@end
