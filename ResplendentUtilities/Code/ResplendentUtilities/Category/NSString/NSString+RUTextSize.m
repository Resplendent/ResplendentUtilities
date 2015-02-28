//
//  NSString+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 8/7/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSString+RUTextSize.h"
#import "UIView+RUUtility.h"





@implementation NSString (RUTextSize)

- (CGSize)ruTextSizeWithBoundingWidth:(CGFloat)boundingWidth attributes:(NSDictionary *)attributes
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"  // sizeWithFont:constrainedToSize:lineBreakMode: has been deprecated
		return [self sizeWithFont:font constrainedToSize:CGSizeMake(boundingWidth, 0) lineBreakMode:style.lineBreakMode];
#pragma clang diagnostic pop
	}
	else
	{
		NSAssert(false, @"not supported");
		return CGSizeZero;
	}
}

@end
