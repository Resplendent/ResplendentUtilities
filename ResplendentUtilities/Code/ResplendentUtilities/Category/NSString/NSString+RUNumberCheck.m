//
//  NSString+RUNumberCheck.m
//  Nifti
//
//  Created by Benjamin Maer on 12/14/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "NSString+RUNumberCheck.h"





@implementation NSString (RUNumberCheck)

-(BOOL)ru_isNumber
{
	NSMutableCharacterSet* decimalsAndDots = [NSMutableCharacterSet decimalDigitCharacterSet];
	[decimalsAndDots addCharactersInString:@"."];
	return ([self rangeOfCharacterFromSet:[decimalsAndDots invertedSet]].location == NSNotFound);
//	return ([self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound);
}

@end
