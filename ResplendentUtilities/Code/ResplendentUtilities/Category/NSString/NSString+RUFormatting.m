//
//  NSString+RUFormatting.m
//  Camerama
//
//  Created by Benjamin Maer on 10/14/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "NSString+RUFormatting.h"





@implementation NSString (RUFormatting)

-(NSString*)ru_stringByRemovingCharactersFromSet:(NSCharacterSet*)characterSet
{
	NSString* properlyFormattedPhoneNumber = [[self componentsSeparatedByCharactersInSet:characterSet]componentsJoinedByString:@""];
	
	return properlyFormattedPhoneNumber;
}

-(NSString*)ru_stringByRemovingAllButDecimals
{
	return [self ru_stringByRemovingCharactersFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
}

@end
