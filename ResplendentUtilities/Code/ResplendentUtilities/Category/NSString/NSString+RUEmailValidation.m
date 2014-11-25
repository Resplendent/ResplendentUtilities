//
//  NSString+RUEmailValidation.m
//  Nifti
//
//  Created by Benjamin Maer on 11/24/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "NSString+RUEmailValidation.h"





@implementation NSString (RUEmailValidation)

-(BOOL)ru_isValidEmailAddress
{
	NSString* const validEmailExpression = @"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$";
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",validEmailExpression] evaluateWithObject:self];
}

@end
