//
//  RUCredentialInputView.m
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCredentialInputView.h"
#import "CALayer+Mask.h"


@interface RUCredentialInputView ()

-(void)updateBorderConsideringCorners;

@end


@implementation RUCredentialInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor greenColor]];
        // Initialization code
        _inputTextField = [UITextField new];
//        [_inputTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_inputTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//        [_inputTextField setFont:inputLabelFont];
//        [_inputTextField setTextColor:inputLabelColor];
        [_inputTextField setReturnKeyType:UIReturnKeyNext];
//        [_inputTextField setTextColor:[UIColor darkMemeniTextColor]];
//        [_inputTextField setSecureTextEntry:inputTextSecure];
        [_inputTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self addSubview:_inputTextField];
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_inputTextField setFrame:self.inputTextFieldFrame];

    if (_cornerRadius && _cornerRadius)
    {
        _path = [self.layer applyMaskWithRoundedCorners:_cornerMasks radius:_cornerRadius];
        [_path setLineWidth:_borderWidth];
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
    [super drawRect:rect];

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

-(BOOL)becomeFirstResponder
{
    return [_inputTextField becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    return [_inputTextField resignFirstResponder];
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

#pragma mark - Getter methods
-(CGRect)inputTextFieldFrame
{
    return (CGRect){_textFieldHorizontalPadding,0,CGRectGetWidth(self.bounds) - _textFieldHorizontalPadding,CGRectGetHeight(self.bounds)};
}

@end

