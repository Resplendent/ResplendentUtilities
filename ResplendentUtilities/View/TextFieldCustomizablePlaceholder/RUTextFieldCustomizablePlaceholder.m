//
//  RUTextFieldCustomizablePlaceholder.m
//  Albumatic
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUTextFieldCustomizablePlaceholder.h"
#import "UIView+Utility.h"
#import "PASystemVersionUtils.h"

#import "RUConstants.h"

@implementation RUTextFieldCustomizablePlaceholder

-(void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.placeholderColor)
    {
        [self.placeholderColor setFill];
    }

    if (self.placeholderFont && self.placeholder.length)
    {
        [[self placeholder] drawInRect:rect withFont:self.placeholderFont];
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += self.placeholderLeftPadding;
    editingRect.size.width -= self.placeholderLeftPadding;
    return editingRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += self.placeholderLeftPadding;
    textRect.size.width -= self.placeholderLeftPadding;
    return textRect;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        switch (self.contentVerticalAlignment)
        {
            case UIControlContentVerticalAlignmentCenter:
                placeholderRect.origin.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(self.placeholderFont.pointSize, CGRectGetHeight(self.bounds));
                break;
                
            default:
                break;
        }
    }

    return placeholderRect;
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
