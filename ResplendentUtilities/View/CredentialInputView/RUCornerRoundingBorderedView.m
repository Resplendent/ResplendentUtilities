//
//  RUCornerRoundingBorderedView.m
//  Albumatic
//
//  Created by Benjamin Maer on 2/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCornerRoundingBorderedView.h"
#import "CALayer+Mask.h"

@interface RUCornerRoundingBorderedView ()

-(void)updateBorderConsideringCorners;

@end

@implementation RUCornerRoundingBorderedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_cornerMasks && _cornerRadius)
    {
        _path = [self.layer applyMaskWithRoundedCorners:_cornerMasks radius:_cornerRadius];
        [_path setLineWidth:_borderWidth * 2.0f];
        [self setNeedsDisplay];
    }
    else
    {
        _path = nil;
        [self setNeedsDisplay];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    if (_path)
    {
        [_borderColor setStroke];
        [_path stroke];
    }
}

#pragma mark - Private methods
-(void)updateBorderConsideringCorners
{
    if (_cornerMasks && _cornerRadius)
    {
        [self.layer setBorderColor:nil];
        [self.layer setBorderWidth:0];
    }
    else
    {
        _path = nil;
        if (_borderColor)
            [self.layer setBorderColor:_borderColor.CGColor];
        
        if (_borderWidth)
            [self.layer setBorderWidth:_borderWidth];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter methods
-(void)setCornerMasks:(UIRectCorner)cornerMasks
{
    if (_cornerMasks == cornerMasks)
        return;
    
    _cornerMasks = cornerMasks;
    
    [self updateBorderConsideringCorners];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    if (_borderColor == borderColor)
        return;
    
    _borderColor = borderColor;
    
    [self updateBorderConsideringCorners];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if (_borderWidth == borderWidth)
        return;
    
    _borderWidth = borderWidth;
    
    [self updateBorderConsideringCorners];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius)
        return;
    
    _cornerRadius = cornerRadius;
    
    [self updateBorderConsideringCorners];
}

@end
