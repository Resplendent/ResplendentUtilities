//
//  UIView+RUCoreGraphics.m
//  Resplendent
//
//  Created by Benjamin Maer on 9/1/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UIView+RUCoreGraphics.h"

@implementation UIView (CoreGraphics)

#pragma mark - Draw rect helper methods
-(void)ru_drawBackgroundColor:(CGContextRef)context
{
    ru_drawColoredRect(context, self.bounds, self.backgroundColor.CGColor, YES);
}

-(void)ru_drawOverLine:(CGContextRef)context colorRef:(CGColorRef)colorRef lineWidth:(CGFloat)lineWidth padding:(CGFloat)padding
{
    CGFloat top = lineWidth / 2.0f;
    ru_drawLine(context, lineWidth, colorRef, (CGPoint){padding, top}, (CGPoint){CGRectGetWidth(self.frame) - padding, top});
}

-(void)ru_drawUnderLine:(CGContextRef)context colorRef:(CGColorRef)colorRef lineWidth:(CGFloat)lineWidth padding:(CGFloat)padding
{
    CGFloat top = CGRectGetHeight(self.bounds) - lineWidth / 2.0f;
    ru_drawLine(context, lineWidth, colorRef, (CGPoint){padding, top}, CGPointMake(CGRectGetWidth(self.frame) - padding, top));
}

#pragma mark - Line methods
void ru_drawLine(CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGPoint startPoint, CGPoint endPoint)
{
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextSetStrokeColorWithColor(context, lineColor);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextStrokePath(context);
}

void ru_drawColorArrayLine(CGContextRef context, CGFloat lineWidth, CGFloat lineColorArray[], CGPoint startPoint, CGPoint endPoint)
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorspace, lineColorArray);
    ru_drawLine(context, lineWidth, color, startPoint, endPoint);
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
}

#pragma mark - Rectangle methods
void ru_drawColoredRect(CGContextRef context, CGRect rect, CGColorRef color, bool colorFill)
{
    if (color)
    {
        if (colorFill)
        {
            CGContextSetFillColorWithColor(context, color);
            CGContextFillRect(context, rect);
        }
        else
        {
            CGContextSetStrokeColorWithColor(context, color);
            CGContextStrokeRect(context, rect);
        }
    }
}

#pragma mark - Gradient methods
void ru_drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
