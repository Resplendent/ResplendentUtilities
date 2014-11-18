//
//  UIView+RUSubviews.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/24/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "UIView+RUSubviews.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@implementation UIView (RUSubviews)

-(UIView *)ruLowestSubview
{
    UIView* lowestSubview = nil;
    for (UIView* subview in self.subviews)
    {
        if (!lowestSubview ||
            (CGRectGetMaxY(lowestSubview.frame) < CGRectGetMaxY(subview.frame)))
        {
            lowestSubview = subview;
        }
    }
    
    return lowestSubview;
}

-(UIView *)ruFirstResponderSubview
{
    for (UIView* subview in self.subviews)
    {
        if (subview.isFirstResponder)
        {
            return subview;
        }
    }
    
    return nil;
}

#pragma mark - Subviews From Point
-(UIView*)ru_frontMostSubviewOfPoint:(CGPoint)point withEvent:(UIEvent *)event
{
	return [self ru_enumerateTranslatedPointsOnSubviews:self.subviews fromPoint:point event:event block:^UIView *(UIView *subview, CGPoint translatedPoint) {

		UIView* subview_frontMostSubviewOfPoint = [subview ru_frontMostSubviewOfPoint:translatedPoint withEvent:event];
		if (subview_frontMostSubviewOfPoint)
		{
			return subview_frontMostSubviewOfPoint;
		}

		if ([subview pointInside:translatedPoint withEvent:event])
		{
			return subview;
		}
		
		return nil;
		
	}];
}

-(UIView*)ru_subviewFromSubviews:(NSArray*)subviews inPoint:(CGPoint)point fromEvent:(UIEvent *)event
{
	return [self ru_enumerateTranslatedPointsOnSubviews:subviews fromPoint:point event:event block:^UIView *(UIView *subview, CGPoint translatedPoint) {

		if ([subview pointInside:translatedPoint withEvent:event])
		{
			return subview;
		}

		return nil;

	}];
}

-(UIView*)ru_enumerateTranslatedPointsOnSubviews:(NSArray*)subviews fromPoint:(CGPoint)point event:(UIEvent *)event block:(UIView*(^)(UIView* subview, CGPoint translatedPoint))block
{
	kRUConditionalReturn_ReturnValueNil(block == nil, YES);

	for (UIView* subview in subviews)
	{
		if (kRUClassOrNil(subview, UIView) == nil)
		{
			NSAssert(false, @"unhandled");
			continue;
		}
		
		if ([subview isDescendantOfView:self] == false)
		{
			continue;
		}
		
		CGPoint translatedPoint = [subview convertPoint:point fromView:self];

		UIView* returnView = block(subview,translatedPoint);
		if (returnView)
		{
			return returnView;
		}
	}
	
	return nil;
}

@end
