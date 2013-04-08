//
//  RUTextFieldCustomizablePlaceholder.m
//  Albumatic
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUTextFieldCustomizablePlaceholder.h"

@implementation RUTextFieldCustomizablePlaceholder

-(void)drawPlaceholderInRect:(CGRect)rect
{
    [_placeholderColor setFill];
    [[self placeholder] drawInRect:rect withFont:_placeholderFont];
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _placeholderLeftPadding, 0);
}

@end
