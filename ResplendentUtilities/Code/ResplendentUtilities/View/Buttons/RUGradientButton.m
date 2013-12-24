//
//  RUGradientButton.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUGradientButton.h"

@implementation RUGradientButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGPoint start = rect.origin;
//    start.y = 0;
//    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    if (_gradientRef)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, self.bounds);
        CGContextDrawLinearGradient(context, _gradientRef, CGPointZero, (CGPoint){9,CGRectGetHeight(rect)}, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }
    
    [super drawRect:rect];
}

-(void)updateGradientRef
{
    if (_topGradientColor && _bottomGradientColor)
    {
        _colors = [NSArray arrayWithObjects:(id)_topGradientColor.CGColor, (id)_bottomGradientColor.CGColor, nil];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _gradientRef = CGGradientCreateWithColors(colorSpace,(__bridge CFArrayRef) _colors, NULL);
        [self setNeedsDisplay];
    }
}

-(void)setTopGradientColor:(UIColor *)topGradientColor
{
    _topGradientColor = topGradientColor;
    [self updateGradientRef];
}

-(void)setBottomGradientColor:(UIColor *)bottomGradientColor
{
    _bottomGradientColor = bottomGradientColor;
    [self updateGradientRef];
}

@end
