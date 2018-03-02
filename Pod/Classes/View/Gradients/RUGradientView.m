//
//  RUGradientView.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/22/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUGradientView.h"
#import "UIView+RUCoreGraphics.h"
#import "RUConstants.h"





@interface RUGradientView ()

#pragma mark - readyToDrawGradient
-(BOOL)readyToDrawGradient;

#pragma mark - gradient
-(CGPoint)gradientStartPoint;
-(CGPoint)gradientEndPoint;

@end





@implementation RUGradientView

#pragma mark - UIView
- (void)drawRect:(CGRect)rect
{
    CGContextRef const context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);

    [super drawRect:rect];

    [self ru_drawBackgroundColor:context];

    if ([self readyToDrawGradient])
    {
        CGGradientRef const gradientRef = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),(__bridge CFArrayRef) @[(id)_startGradientColor.CGColor, (id)_endGradientColor.CGColor], NULL);
        CGContextDrawLinearGradient(context, gradientRef, self.gradientStartPoint, self.gradientEndPoint, 0);
        CGGradientRelease(gradientRef);
    }
}

#pragma mark - init
-(nullable instancetype)initWithStartGradientColor:(nullable UIColor*)startGradientColor
								  endGradientColor:(nullable UIColor*)endGradientColor
{
	if (self = [self init])
	{
		[self setStartGradientColor:startGradientColor];
		[self setEndGradientColor:endGradientColor];
	}
	
	return self;
}

#pragma mark - gradient
-(CGPoint)gradientStartPoint
{
    switch (self.gradientDirection)
    {
        case RUGradientViewDirectionVertical:
            return (CGPoint){CGRectGetWidth(self.bounds) / 2.0f,0};
			break;

        case RUGradientViewDirectionHorizontal:
            return (CGPoint){0,CGRectGetHeight(self.bounds) / 2.0f};
			break;
    }

	NSAssert(false, RUStringWithFormat(@"Unhandled gradientDirection %lu",(unsigned long)self.gradientDirection));
    return CGPointZero;
}

-(CGPoint)gradientEndPoint
{
    switch (self.gradientDirection)
    {
        case RUGradientViewDirectionVertical:
            return (CGPoint){CGRectGetWidth(self.bounds) / 2.0f,CGRectGetHeight(self.bounds)};
			break;
            
        case RUGradientViewDirectionHorizontal:
            return (CGPoint){CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds) / 2.0f};
			break;
    }

	NSAssert(false, RUStringWithFormat(@"Unhandled gradientDirection %lu",(unsigned long)self.gradientDirection));
    return CGPointZero;
}

#pragma mark - startGradientColor
-(void)setStartGradientColor:(UIColor *)startGradientColor
{
    if (self.startGradientColor == startGradientColor)
        return;

    _startGradientColor = startGradientColor;

    if (self.readyToDrawGradient)
	{
		[self setNeedsDisplay];
	}
}

#pragma mark - endGradientColor
-(void)setEndGradientColor:(UIColor *)endGradientColor
{
    if (self.endGradientColor == endGradientColor)
        return;

    _endGradientColor = endGradientColor;

    if (self.readyToDrawGradient)
	{
		[self setNeedsDisplay];
	}
}

#pragma mark - readyToDrawGradient
-(BOOL)readyToDrawGradient
{
    return (_startGradientColor && _endGradientColor);
}

@end
