//
//  UITextField+RUSelectedTextRange.m
//  Nifti
//
//  Created by Benjamin Maer on 12/15/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UITextField+RUSelectedTextRange.h"





@implementation UITextField (RUSelectedTextRange)

-(void)ru_setSelectedTextRangeWithOffset:(NSInteger)selectedTextRangeOffset
{
	UITextRange* selectedTextRange = self.selectedTextRange;
	UITextPosition* newStartPosition = [self positionFromPosition:selectedTextRange.start offset:selectedTextRangeOffset];
	UITextPosition* newEndPosition = [self positionFromPosition:selectedTextRange.start offset:selectedTextRangeOffset];
	UITextRange* newRange = [self textRangeFromPosition:newStartPosition toPosition:newEndPosition];

	[self setSelectedTextRange:newRange];
}

@end
