//
//  NSString+RUStringContainsUtil.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 9/19/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSString+RUStringContainsUtil.h"





@implementation NSString (RUStringContainsUtil)

-(BOOL)ruContainsOnlyNumericAndDecimalCharacters
{
	static NSCharacterSet* allNonDecimals;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		NSMutableCharacterSet* allNonDecimalsMutable = [NSMutableCharacterSet decimalDigitCharacterSet];
		[allNonDecimalsMutable addCharactersInString:@"."];
		[allNonDecimalsMutable invert];
		
		allNonDecimals = [allNonDecimalsMutable copy];
		
	});
	
	return [self rangeOfCharacterFromSet:allNonDecimals].location == NSNotFound;
}

@end
