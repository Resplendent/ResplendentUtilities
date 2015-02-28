//
//  UIView+RUDrawHole.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 3/12/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "UIView+RUDrawHole.h"





@implementation UIView (RUDrawHole)

-(void)drawHoleInRect:(CGRect)rect radius:(CGFloat)radius context:(CGContextRef)context
{
	// Create the "visible" path, which will be the shape that gets the inner shadow
	// In this case it's just a rounded rect, but could be as complex as your want
	CGMutablePathRef visiblePath = CGPathCreateMutable();
	CGRect innerRect = CGRectInset(rect, radius, radius);
	CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, rect.origin.y);
	CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, rect.origin.y);
	CGPathAddArcToPoint(visiblePath, NULL, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, innerRect.origin.y, radius);
	CGPathAddLineToPoint(visiblePath, NULL, rect.origin.x + rect.size.width, innerRect.origin.y + innerRect.size.height);
	CGPathAddArcToPoint(visiblePath, NULL,  rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, innerRect.origin.x + innerRect.size.width, rect.origin.y + rect.size.height, radius);
	CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, rect.origin.y + rect.size.height);
	CGPathAddArcToPoint(visiblePath, NULL,  rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, innerRect.origin.y + innerRect.size.height, radius);
	CGPathAddLineToPoint(visiblePath, NULL, rect.origin.x, innerRect.origin.y);
	CGPathAddArcToPoint(visiblePath, NULL,  rect.origin.x, rect.origin.y, innerRect.origin.x, rect.origin.y, radius);
	CGPathCloseSubpath(visiblePath);
	
	// Fill this path
	UIColor *aColor = [UIColor clearColor];
	[aColor setFill];
	CGContextAddPath(context, visiblePath);
	CGContextSetBlendMode(context, kCGBlendModeSourceOut);
	CGContextFillPath(context);
}

@end
