//
//  RUTriangle.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/10/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUTriangle.h"

@interface RUTriangle ()

-(void)drawTriangleAndColorInRect:(CGRect)rect;

@end

@implementation RUTriangle

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [self drawTriangleAndColorInRect:rect];
}

#pragma mark - Drawing
-(void)drawTrianglePathInRect:(CGRect)rect withContent:(CGContextRef)context
{
    switch (self.orientation)
    {
        case RUTriangleOrientationRight:
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMidY(rect));  // right middle
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
            break;

        case RUTriangleOrientationLeft:
            CGContextMoveToPoint   (context, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));  // left middle
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom right
            break;

        case RUTriangleOrientationDown:
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));  // top left
            CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));  // bottom middle
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));  // top right
            break;

        case RUTriangleOrientationUp:
            CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
            CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect));  // top middle
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // bottom right
            break;
    }
}

-(void)drawTriangleAndColorInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);

    [self drawTrianglePathInRect:rect withContent:context];

    CGContextClosePath(context);

    if (self.fillTriangle)
    {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        CGContextFillPath(context);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - Setters
-(void)setColor:(UIColor *)color
{
    if (self.color == color)
        return;

    _color = color;

    [self setNeedsDisplay];
}

-(void)setOrientation:(RUTriangleOrientation)orientation
{
    if (self.orientation == orientation)
        return;

    _orientation = orientation;

    [self setNeedsDisplay];
}

@end
