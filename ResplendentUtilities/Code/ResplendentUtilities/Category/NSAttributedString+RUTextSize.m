//
//  NSAttributedString+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/4/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSAttributedString+RUTextSize.h"
#import "UIView+RUUtility.h"





@implementation NSAttributedString (RUTextSize)

- (CGSize)ru_textSizeWithBoundingWidth:(CGFloat)boundingWidth
{
	if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)])
	{
		CGSize boundingSize = (CGSize){.width = boundingWidth,.height = 0};
		NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine);
		CGRect textBoundingRect = [self boundingRectWithSize:boundingSize options:options context:nil];
		
		return CGRectSizeThatFitsRect(textBoundingRect);
	}
	else
	{
		NSAssert(false, @"not supported");
		return CGSizeZero;
	}

}

@end
