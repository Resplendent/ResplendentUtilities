//
//  RUScrollView.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUScrollView.h"

@implementation RUScrollView

-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    if (!_disableAutoScrollToSubview)
        [super scrollRectToVisible:rect animated:animated];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_disableTouchesOutsideOfSubviews)
    {
        for (UIView* subview in self.subviews)
        {
            if (CGRectContainsPoint(subview.frame, point))
                return YES;
        }

        return NO;
    }
    else
    {
        return [super pointInside:point withEvent:event];
    }
}

@end
