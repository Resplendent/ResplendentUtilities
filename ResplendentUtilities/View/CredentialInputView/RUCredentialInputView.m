//
//  RUCredentialInputView.m
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCredentialInputView.h"
//#import "CALayer+Mask.h"

@implementation RUCredentialInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _inputTextField = [UITextField new];
        [_inputTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_inputTextField setReturnKeyType:UIReturnKeyNext];
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

//    if (_cornerMasks && _cornerRadius)
//    {
//        _path = [self.layer applyMaskWithRoundedCorners:_cornerMasks radius:_cornerRadius];
//        [_path setLineWidth:_borderWidth * 2.0f];
//        [self setNeedsDisplay];
//    }
//    else
//    {
//        _path = nil;
//        [self setNeedsDisplay];
//    }
}

//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, self.bounds);
//
//    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
//    CGContextFillRect(context, self.bounds);
//
//    if (_path)
//    {
//        [_borderColor setStroke];
//        [_path stroke];
//    }
//}

-(BOOL)becomeFirstResponder
{
    return [_inputTextField becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    return [_inputTextField resignFirstResponder];
}

#pragma mark - Getter methods
-(CGRect)inputTextFieldFrame
{
    return (CGRect){_textFieldHorizontalPadding,0,CGRectGetWidth(self.bounds) - (_textFieldHorizontalPadding * 2.0f),CGRectGetHeight(self.bounds)};
}

@end

