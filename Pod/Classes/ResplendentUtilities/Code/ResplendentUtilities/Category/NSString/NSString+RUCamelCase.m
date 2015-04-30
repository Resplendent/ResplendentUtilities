//
//  NSString+RUCamelCase.m
//  Shimmur
//
//  Created by Benjamin Maer on 4/24/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "NSString+RUCamelCase.h"
#import "RUConditionalReturn.h"




@implementation NSString (RUCamelCase)

-(NSString*)ru_camelCasedString_lowercaseFirstLetter:(BOOL)lowercaseFirstLetter
{
	kRUConditionalReturn_ReturnValue(self.length == 0, NO, self);

	NSString* camelCasedString = [[self capitalizedString]stringByReplacingOccurrencesOfString:@" " withString:@""];

	if (lowercaseFirstLetter)
	{
		NSMutableString* camelCasedString_mutable = [camelCasedString mutableCopy];
		NSString* firstLetter = [camelCasedString substringToIndex:1];
		[camelCasedString_mutable replaceCharactersInRange:NSMakeRange(0, 1) withString:firstLetter.lowercaseString];
		camelCasedString = [camelCasedString_mutable copy];
	}

	return camelCasedString;
}

@end
