//
//  NSString+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 8/7/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSString+RUTextSize.h"





@implementation NSString (RUTextSize)

- (CGSize)textSizeWithBoundingWidth:(CGFloat)boundingWidth attributes:(NSDictionary *)attributes
{
	if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
	{
		CGSize boundingSize = (CGSize){.width = boundingWidth,.height = 0};
		NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine);
		CGRect textBoundingRect = [self boundingRectWithSize:boundingSize options:options attributes:attributes context:nil];
		
		return CGRectSizeThatFitsRect(textBoundingRect);
	}
	else if ((&NSFontAttributeName) &&
			 (&NSParagraphStyleAttributeName))
	{
		UIFont* font = [attributes objectForKey:NSFontAttributeName];
		NSParagraphStyle *style = [attributes objectForKey:NSParagraphStyleAttributeName];
		return [self sizeWithFont:font constrainedToSize:CGSizeMake(boundingWidth, 0) lineBreakMode:style.lineBreakMode];
	}
	else
	{
		NSAssert(false, @"not supported");
		return CGSizeZero;
	}
}

@end
