//
//  RUScrollView.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUScrollView.h"
#import "UIView+RUSubviews.h"





@implementation RUScrollView

-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    if (!self.disableAutoScrollToSubview)
    {
        [super scrollRectToVisible:rect animated:animated];
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.touchesInsideState == RUScrollViewTouchesInsideStateIncludeSubviews ||
		self.touchesInsideState == RUScrollViewTouchesInsideStateOnlySubviews)
    {
		if ([self ru_frontMostSubviewOfPoint:point withEvent:event])
		{
			return YES;
		}
    }

	if (self.touchesInsideState != RUScrollViewTouchesInsideStateOnlySubviews)
	{
		return [super pointInside:point withEvent:event];
	}
	else
	{
		return NO;
	}
}

@end
