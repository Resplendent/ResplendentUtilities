//
//  RUGradientView.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/22/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUGradientView.h"
#import "UIView+CoreGraphics.h"

@interface RUGradientView ()

@property (nonatomic, readonly) BOOL readyToDrawGradient;

@end

@implementation RUGradientView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);

    [super drawRect:rect];

    [self RUDrawBackgroundColor:context];

    if (self.readyToDrawGradient)
    {
        CGFloat xCoord = CGRectGetWidth(rect) / 2.0f;
        CGGradientRef gradientRef = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),(__bridge CFArrayRef) @[(id)_topGradientColor.CGColor, (id)_bottomGradientColor.CGColor], NULL);
        CGContextDrawLinearGradient(context, gradientRef, (CGPoint){xCoord,0}, (CGPoint){xCoord,CGRectGetHeight(rect)}, 0);
        CGGradientRelease(gradientRef);

    }
}

#pragma mark - Setter methods
-(void)setTopGradientColor:(UIColor *)topGradientColor
{
    _topGradientColor = topGradientColor;
    if (self.readyToDrawGradient)
        [self setNeedsDisplay];
}

-(void)setBottomGradientColor:(UIColor *)bottomGradientColor
{
    _bottomGradientColor = bottomGradientColor;
    if (self.readyToDrawGradient)
        [self setNeedsDisplay];
}

#pragma mark - Getter methods
-(BOOL)readyToDrawGradient
{
    return (_topGradientColor && _bottomGradientColor);
}

#pragma mark - Static Constructors
+(instancetype)gradientViewWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor
{
    RUGradientView* gradientView = [self new];
    [gradientView setTopGradientColor:topColor];
    [gradientView setBottomGradientColor:bottomColor];
    return gradientView;
}

@end
