//
//  NSString+RUUrlParams.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 8/31/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSString+RUURLParams.h"
#import "NSMutableDictionary+RUUtil.h"





@implementation NSString (RUURLParams)

-(NSDictionary*)ruURLParams
{
	if (self.length == 0)
	{
		return nil;
	}

	NSArray* components = [self componentsSeparatedByString:@","];

	NSMutableDictionary* ruURLParams = [NSMutableDictionary dictionaryWithCapacity:components.count];
	for (NSString* component in components)
	{
		NSRange equalRange = [component rangeOfString:@"="];
		if (equalRange.location != NSNotFound)
		{
			NSString* key = [component substringToIndex:equalRange.location];
			NSString* value = [component substringFromIndex:equalRange.location + equalRange.length];
			[ruURLParams setObjectOrRemoveIfNil:value forKey:key];
		}
	}

	return [ruURLParams copy];
}

@end
