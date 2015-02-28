//
//  UILabel+RUTextSize.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "UILabel+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"
#import "NSAttributedString+RUTextSize.h"





@implementation UILabel (RUTextSize)

-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width
{
	if ([self respondsToSelector:@selector(attributedText)] &&
		(self.attributedText.length))
	{
		return [self.attributedText ru_textSizeWithBoundingWidth:width];
	}
	else if (([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
		([self.text respondsToSelector:@selector(ruTextSizeWithBoundingWidth:attributes:)]))
	{
		RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[attributesDictionaryBuilder absorbPropertiesFromLabel:self];
		return [self.text ruTextSizeWithBoundingWidth:width attributes:[attributesDictionaryBuilder createAttributesDictionary]];
	}
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:self.lineBreakMode];
#pragma clang diagnostic pop
	}
}

-(CGSize)ruTextSize
{
	return [self ruTextSizeConstrainedToWidth:CGFLOAT_MAX];
}

@end
