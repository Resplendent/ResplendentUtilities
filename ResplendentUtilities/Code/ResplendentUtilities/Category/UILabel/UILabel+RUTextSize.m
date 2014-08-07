//
//  UILabel+RUTextSize.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "UILabel+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"





@implementation UILabel (RUTextSize)

-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width
{
	if ([self.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
	{
		RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[attributesDictionaryBuilder absorbPropertiesFromLabel:self];
		CGSize textSize = CGSizeMake(width, CGFLOAT_MAX);
		CGRect textBoundingRect = [self.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[attributesDictionaryBuilder createAttributesDictionary] context:nil];
		
		return (CGSize){.width = CGRectGetMaxX(textBoundingRect),.height = CGRectGetMaxY(textBoundingRect)};
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
