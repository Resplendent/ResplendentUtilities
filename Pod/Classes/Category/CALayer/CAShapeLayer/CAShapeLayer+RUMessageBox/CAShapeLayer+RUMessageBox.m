//
//  CAShapeLayer+RUMessageBox.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 3/12/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAShapeLayer+RUMessageBox.h"





@implementation CAShapeLayer (RUMessageBox)

#pragma mark - messageBox
+(nonnull CAShapeLayer*)ru_messageBoxMask_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius
{
	CAShapeLayer* const mask = [CAShapeLayer new];
	[mask setFrame:rect];
	[mask setFillColor:[UIColor blackColor].CGColor];
	
	UIBezierPath* const bezierPath = [self ru_messageBoxPath_with_rect:mask.bounds arrowHeight:arrowHeight arrowWidth:arrowWidth arrowLeftPadding:arrowLeftPadding cornerRadius:cornerRadius];
	[mask setPath:[bezierPath CGPath]];

	return mask;
}

+(nonnull UIBezierPath*)ru_messageBoxPath_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius
{
	CGMutablePathRef const path = CGPathCreateMutable();
	
	CGRect const shellRect = [self ru_messageBoxShellRect_with_rect:rect arrowHeight:arrowHeight];
	CGRect const innerRect = CGRectInset(shellRect, cornerRadius, cornerRadius);
	
	/* Shell */
	CGPathMoveToPoint(path, NULL, innerRect.origin.x, shellRect.origin.y);
	CGPathAddArcToPoint(path, NULL,  shellRect.origin.x, shellRect.origin.y, shellRect.origin.x, innerRect.origin.y, cornerRadius);
	CGPathAddLineToPoint(path, nil, CGRectGetMinX(shellRect), CGRectGetMaxY(innerRect));
	CGPathAddArcToPoint(path, NULL,  CGRectGetMinX(shellRect), CGRectGetMaxY(shellRect), CGRectGetMinX(innerRect), CGRectGetMaxY(shellRect), cornerRadius);
	CGPathAddLineToPoint(path, nil, CGRectGetMaxX(innerRect), CGRectGetMaxY(shellRect));
	CGPathAddArcToPoint(path, NULL,  CGRectGetMaxX(shellRect), CGRectGetMaxY(shellRect), CGRectGetMaxX(shellRect), CGRectGetMaxY(innerRect), cornerRadius);
	CGPathAddLineToPoint(path, nil, CGRectGetMaxX(shellRect), CGRectGetMinY(innerRect));
	CGPathAddArcToPoint(path, NULL,  CGRectGetMaxX(shellRect), CGRectGetMinY(shellRect), CGRectGetMaxX(innerRect), CGRectGetMinY(shellRect), cornerRadius);
	
	/* Triangle */
	CGPathAddLineToPoint(path, nil, CGRectGetMinX(shellRect) + arrowLeftPadding + arrowWidth, arrowHeight);
	CGPathAddLineToPoint(path, nil, CGRectGetMinX(shellRect) + arrowLeftPadding + (arrowWidth / 2.0f), 0);
	CGPathAddLineToPoint(path, nil, CGRectGetMinX(shellRect) + arrowLeftPadding, arrowHeight);
	
	/* End */
	CGPathCloseSubpath(path);

	UIBezierPath* const bezierPath = [UIBezierPath bezierPath];
	[bezierPath setCGPath:path];

	CGPathRelease(path);

	return bezierPath;
}

+(CGRect)ru_messageBoxShellRect_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight
{
	return
	UIEdgeInsetsInsetRect(rect,
						  (UIEdgeInsets){
							 .top	= arrowHeight,
						  });
}

@end
