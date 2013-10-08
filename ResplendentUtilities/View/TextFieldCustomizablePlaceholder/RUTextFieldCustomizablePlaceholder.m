//
//  RUTextFieldCustomizablePlaceholder.m
//  Albumatic
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUTextFieldCustomizablePlaceholder.h"
#import "UIView+Utility.h"

@implementation RUTextFieldCustomizablePlaceholder

-(void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.placeholderColor)
    {
        [self.placeholderColor setFill];
    }

    if (self.placeholderFont && self.placeholder.length)
    {
        CGFloat fontHeight = self.placeholderFont.pointSize;
        CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(fontHeight, CGRectGetHeight(rect));
        CGRect placeholderRect = (CGRect){0, yCoord, CGRectGetWidth(rect), fontHeight};
        [self.placeholder drawInRect:placeholderRect withFont:self.placeholderFont];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView* subview in self.subviews)
    {
        CGRect rect = subview.frame;
        CGFloat placeholderLeftPadding = self.placeholderLeftPadding;
        rect.origin.x += placeholderLeftPadding;
        rect.size.width -= placeholderLeftPadding;
        [subview setFrame:rect];
    }
}

#pragma mark - Setters
-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    if (self.placeholderFont == placeholderFont)
        return;
    
    _placeholderFont = placeholderFont;
    
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (self.placeholderColor == placeholderColor)
        return;
    
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

-(void)setPlaceholderLeftPadding:(CGFloat)placeholderLeftPadding
{
    if (self.placeholderLeftPadding == placeholderLeftPadding)
        return;

    _placeholderLeftPadding = placeholderLeftPadding;

    [self setNeedsDisplay];
}

@end
