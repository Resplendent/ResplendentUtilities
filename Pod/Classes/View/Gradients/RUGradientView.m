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

@property (nonatomic, readonly) BOOL readyToDrawGradient;

-(CGPoint)gradientStartPoint;
-(CGPoint)gradientEndPoint;

@end





@implementation RUGradientView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);

    [super drawRect:rect];

    [self ru_drawBackgroundColor:context];

    if (self.readyToDrawGradient)
    {
        CGGradientRef gradientRef = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),(__bridge CFArrayRef) @[(id)_startGradientColor.CGColor, (id)_endGradientColor.CGColor], NULL);
        CGContextDrawLinearGradient(context, gradientRef, self.gradientStartPoint, self.gradientEndPoint, 0);
        CGGradientRelease(gradientRef);

    }
}

#pragma mark - Gradient Points
-(CGPoint)gradientStartPoint
{
    switch (self.gradientDirection)
    {
        case RUGradientViewDirectionVertical:
            return (CGPoint){CGRectGetWidth(self.bounds) / 2.0f,0};

        case RUGradientViewDirectionHorizontal:
            return (CGPoint){0,CGRectGetHeight(self.bounds) / 2.0f};

        default:
            NSAssert(false, RUStringWithFormat(@"Unhandled gradientDirection %lu",(unsigned long)self.gradientDirection));
            break;
    }

    return CGPointZero;
}

-(CGPoint)gradientEndPoint
{
    switch (self.gradientDirection)
    {
        case RUGradientViewDirectionVertical:
            return (CGPoint){CGRectGetWidth(self.bounds) / 2.0f,CGRectGetHeight(self.bounds)};
            
        case RUGradientViewDirectionHorizontal:
            return (CGPoint){CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds) / 2.0f};

        default:
            NSAssert(false, RUStringWithFormat(@"Unhandled gradientDirection %lu",(unsigned long)self.gradientDirection));
            break;
    }

    return CGPointZero;
}

#pragma mark - Setter methods
-(void)setStartGradientColor:(UIColor *)startGradientColor
{
    if (self.startGradientColor == startGradientColor)
        return;

    _startGradientColor = startGradientColor;

    if (self.readyToDrawGradient)
        [self setNeedsDisplay];
}

-(void)setEndGradientColor:(UIColor *)endGradientColor
{
    if (self.endGradientColor == endGradientColor)
        return;

    _endGradientColor = endGradientColor;

    if (self.readyToDrawGradient)
        [self setNeedsDisplay];
}

#pragma mark - Getter methods
-(BOOL)readyToDrawGradient
{
    return (_startGradientColor && _endGradientColor);
}

#pragma mark - Static Constructors
-(id)initWithStartGradientColor:(UIColor*)startGradientColor endGradientColor:(UIColor*)endGradientColor
{
    if (self = [self init])
    {
        [self setStartGradientColor:startGradientColor];
        [self setEndGradientColor:endGradientColor];
    }

    return self;
}

@end
