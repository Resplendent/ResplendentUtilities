//
//  UIView+RUSubviews.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/24/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "UIView+RUSubviews.h"





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

@end
