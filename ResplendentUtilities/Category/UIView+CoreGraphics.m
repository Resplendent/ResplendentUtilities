//
//  UIView+CoreGraphics.m
//  Memeni
//
//  Created by Benjamin Maer on 9/1/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UIView+CoreGraphics.h"

@implementation UIView (CoreGraphics)

#pragma mark - Line methods
void drawLine(CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGPoint startPoint, CGPoint endPoint)
{
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextSetStrokeColorWithColor(context, lineColor);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextStrokePath(context);
}

void drawColorArrayLine(CGContextRef context, CGFloat lineWidth, CGFloat lineColorArray[], CGPoint startPoint, CGPoint endPoint)
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorspace, lineColorArray);
    drawLine(context, lineWidth, color, startPoint, endPoint);
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
}

#pragma mark - Gradient methods

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor)
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

#pragma mark - Rounded Rect methods

//Needs to be worked out
void drawRoundedRect(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    CGContextAddLineToPoint(context,
                            rect.origin.x,
                            rect.origin.y + rect.size.height - radius);
    
    CGContextAddArc(context,
                    rect.origin.x + radius,
                    rect.origin.y + rect.size.height - radius,
                    radius, M_PI, M_PI/2, 1);
    
    
    // Only round bottom right corner for full width panels.
//    if ((rect.origin.x + rect.size.width) < self.bounds.size.width) {
//        CGContextAddLineToPoint(context,
//                                rect.origin.x + rect.size.width,
//                                rect.origin.y + rect.size.height);
//    } else {
//        CGContextAddLineToPoint(context,
//                                self.bounds.size.width - radius,
//                                self.bounds.size.height);
//        
//        CGContextAddArc(context,
//                        self.bounds.size.width - radius,
//                        self.bounds.size.height - radius,
//                        radius, M_PI/2, 0.0f, 1);
//    }
    
    CGContextAddLineToPoint(context,
                            rect.origin.x + rect.size.width,
                            rect.origin.y + radius);
    
    CGContextAddArc(context,
                    rect.origin.x + rect.size.width - radius,
                    rect.origin.y + radius,
                    radius, 0.0f, -M_PI/2, 1);
    
    CGContextAddLineToPoint(context,
                            rect.origin.x,
                            rect.origin.y);
    
}


@end
