//
//  RURadioButtonView.m
//  Pineapple
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RURadioButtonView.h"
#import "RUCompatability.h"

@implementation RURadioButtonView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    NSUInteger numberOfRows = self.numberOfRows;
    NSUInteger numberOfColumns = ceil((double)self.buttonTitles.count / (double)numberOfRows);
    CGFloat buttonPadding = self.buttonPadding;
    CGFloat buttonWidth = (CGRectGetWidth(rect) + buttonPadding) / (double)numberOfColumns;
    CGFloat buttonHeight = (CGRectGetHeight(rect) + buttonPadding) / (double)numberOfRows;

    __block NSUInteger row = 0;
    __block NSUInteger column = 0;

    [self.buttonTitles enumerateObjectsUsingBlock:^(NSString* buttonTitle, NSUInteger buttonTitleIndex, BOOL *stop) {
        CGFloat xCoord = (row * (buttonWidth + buttonPadding));
        CGFloat yCoord = (column * (buttonHeight + buttonPadding));
        UIColor* textColor = (buttonTitleIndex == self.selectedButtonIndex ? self.selectedTextColor : self.textColor);

        CTFramesetterRef frameSetter = [self drawButtonFrameSetterWithRect:(CGRect){xCoord,yCoord,buttonWidth,buttonHeight} buttonTitle:buttonTitle textColor:textColor];
        CGMutablePathRef textPath = CGPathCreateMutable();
        CGPathAddRect(textPath, NULL,(CGRect){xCoord, -yCoord ,buttonWidth,buttonHeight});

        // left column frame
        CTFrameRef textFrame = CTFramesetterCreateFrame(frameSetter,CFRangeMake(0, 0),textPath, NULL);
        
        CFRelease(textFrame);
        CGPathRelease(textPath);
        CFRelease(frameSetter);
        
        if (row == numberOfColumns - 1)
        {
            row = 0;
            column++;
        }
        else
        {
            row++;
        }
    }];
}

-(CTFramesetterRef)drawButtonFrameSetterWithRect:(CGRect)button buttonTitle:(NSString *)buttonTitle textColor:(UIColor*)textColor
{
    NSAttributedString* attributedString = [[NSAttributedString alloc]initWithString:buttonTitle attributes:@{kRUCompatibleFontAttributeDictPairWithFont(self.font),kRUCompatibleForegroundColorAttributeDictPairWithColor(textColor)}];
    return CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);;
}

#pragma mark - Setters
-(void)setButtonTitles:(NSArray *)buttonTitles
{
    _buttonTitles = buttonTitles;
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    [self setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

-(void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    [self setNeedsDisplay];
}

@end
