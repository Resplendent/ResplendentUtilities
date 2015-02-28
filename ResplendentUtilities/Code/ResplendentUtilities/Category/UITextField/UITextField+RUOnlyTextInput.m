//
//  UITextField+RUOnlyTextInput.m
//  Nifti
//
//  Created by Benjamin Maer on 12/14/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UITextField+RUOnlyTextInput.h"
#import "NSString+RUNumberCheck.h"





@implementation UITextField (RUOnlyTextInput)

- (BOOL)ru_isOnlyTextInputWithTextChangeInRange:(NSRange)range replacementString:(NSString *)string
{
//	// allow backspace
//	if (string.length)
//	{
//		return YES;
//	}
	
	if ([string ru_isNumber] == false)
	{
		return NO;
	}
	
	// verify max length has not been exceeded
	NSString *updatedText = [self.text stringByReplacingCharactersInRange:range withString:string];

	if ([updatedText ru_isNumber] == false)
	{
		return NO;
	}
	
	return YES;
}

@end
