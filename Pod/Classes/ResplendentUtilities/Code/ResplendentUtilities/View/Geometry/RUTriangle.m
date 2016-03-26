//
//  RUTriangle.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/10/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUTriangle.h"
#import "RUConditionalReturn.h"





@interface RUTriangle ()

-(void)drawTriangleAndColorInRect:(CGRect)rect;

@end





@implementation RUTriangle

#pragma mark - UIView
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    [self drawTriangleAndColorInRect:rect];
}

#pragma mark - Drawing
-(void)drawTrianglePathInRect:(CGRect)rect withContent:(nonnull CGContextRef)context
{
	kRUConditionalReturn(context == nil, YES);

	CGContextBeginPath(context);

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

	if (self.enableOpenTriangle == false)
	{
		CGContextClosePath(context);
	}
}

-(void)drawTriangleAndColorInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawTrianglePathInRect:rect withContent:context];
	CGContextSetStrokeColorWithColor(context, self.triangleBorderColor.CGColor);
	CGContextStrokePath(context);

    if (self.fillTriangleColor)
    {
		[self drawTrianglePathInRect:rect withContent:context];
        CGContextSetFillColorWithColor(context, self.fillTriangleColor.CGColor);
        CGContextFillPath(context);
    }
}

#pragma mark - Setters
-(void)setTriangleBorderColor:(UIColor *)triangleBorderColor
{
    if (self.triangleBorderColor == triangleBorderColor)
        return;

    _triangleBorderColor = triangleBorderColor;

    [self setNeedsDisplay];
}

-(void)setFillTriangleColor:(UIColor *)fillTriangleColor
{
	if (self.fillTriangleColor == fillTriangleColor)
	{
		return;
	}

	_fillTriangleColor = fillTriangleColor;

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
