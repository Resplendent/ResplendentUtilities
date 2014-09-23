//
//  UIButton+RUTextSize.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 8/18/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "UIButton+RUTextSize.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"





@implementation UIButton (RUTextSize)

-(CGSize)ruCurrentTitleTextSizeConstrainedToWidth:(CGFloat)width
{
	NSString* currentTitle = self.currentTitle;
	if (([currentTitle respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) &&
		([currentTitle respondsToSelector:@selector(textSizeWithBoundingWidth:attributes:)]))
	{
		RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
		[attributesDictionaryBuilder absorbPropertiesFromButton:self];
		return [currentTitle ruTextSizeWithBoundingWidth:width attributes:[attributesDictionaryBuilder createAttributesDictionary]];
	}
	else
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [currentTitle sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:self.titleLabel.lineBreakMode];
#pragma clang diagnostic pop
	}
}

-(CGSize)ruCurrentTitleTextSize
{
	return [self ruCurrentTitleTextSizeConstrainedToWidth:CGFLOAT_MAX];
}

@end
