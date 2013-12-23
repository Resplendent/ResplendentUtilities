//
//  UIView+CoreGraphics.h
//  Albumatic
//
//  Created by Benjamin Maer on 9/1/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

//Line methods
void drawLine(CGContextRef context, CGFloat lineWidth, CGColorRef lineColor, CGPoint startPoint, CGPoint endPoint);
void drawColorArrayLine(CGContextRef context, CGFloat lineWidth, CGFloat lineColorArray[], CGPoint startPoint, CGPoint endPoint);

//Rectangle Methods
void drawColoredRect(CGContextRef context, CGRect rect, CGColorRef color, bool colorFill);

//Gradient Method
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

@interface UIView (CoreGraphics)

//Draw rect helper methods
-(void)drawOverLine:(CGContextRef)context colorRef:(CGColorRef)colorRef lineWidth:(CGFloat)lineWidth padding:(CGFloat)padding;
-(void)drawUnderLine:(CGContextRef)context colorRef:(CGColorRef)colorRef lineWidth:(CGFloat)lineWidth padding:(CGFloat)padding;

//Helpful for when you need to manually draw the background color
-(void)RUDrawBackgroundColor:(CGContextRef)context;

@end
