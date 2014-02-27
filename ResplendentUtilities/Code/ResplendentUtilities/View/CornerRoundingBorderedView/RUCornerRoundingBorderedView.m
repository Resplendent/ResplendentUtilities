//
//  RUCornerRoundingBorderedView.m
//  Resplendent
//
//  Created by Benjamin Maer on 2/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCornerRoundingBorderedView.h"
#import "UIView+RUUtility.h"
#import "CALayer+RUMask.h"
#import "RUDLog.h"

#import <objc/runtime.h>





NSString* const kRUCornerRoundingBorderedViewTextFieldObservingKey = @"kRUCornerRoundingBorderedViewTextFieldObservingKey";





@interface RUCornerRoundingBorderedView ()

-(void)updateBorderConsideringCorners;

@end





@implementation RUCornerRoundingBorderedView

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_cornerMasks && _cornerRadius)
    {
        _path = [self.layer applyMaskWithRoundedCorners:_cornerMasks radius:_cornerRadius];
        [_path setLineWidth:_borderWidth * 2.0f];
        [self setNeedsDisplay];
    }
    else if (_path)
    {
        _path = nil;
        [self setNeedsDisplay];
    }

    if (_textField)
    {
        [_textField setFrame:self.textFieldFrame];
    }

    if (_switcher)
    {
        [_switcher setFrame:self.switcherFrame];
    }

    if (_label)
    {
        [_label setFrame:self.labelFrame];
    }

    if (_icon)
    {
        [_icon setFrame:self.iconFrame];
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

#pragma mark - Icon methods
-(UIImage *)iconImage
{
    return _icon.image;
}

-(void)setIconImage:(UIImage *)iconImage
{
    if (_icon)
    {
        [_icon setImage:iconImage];
    }
    else
    {
        [NSException raise:NSInternalInconsistencyException format:@"Can't set icon image without first adding icon"];
    }
}

-(CGRect)iconFrame
{
    return (CGRect){_iconLeftPadding,floor((CGRectGetHeight(self.bounds) - self.iconImage.size.height) / 2.0f),self.iconImage.size};
}

-(void)addIcon
{
    if (_icon)
    {
        RUDLog(@"already have icon");
    }
    else
    {
        _icon = [UIImageView new];
        [self addSubview:_icon];
    }
}

#pragma mark - Text Field methods
-(void)addTextField
{
    if (_textField)
    {
        RUDLog(@"already have one");
    }
    else
    {
        _textField = [UITextField new];
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_textField setReturnKeyType:UIReturnKeyNext];
        [_textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self addSubview:_textField];
    }
}

-(CGRect)textFieldFrame
{
    CGRect frame = (CGRect){_textFieldLeftPadding,0,CGRectGetWidth(self.bounds) - (_textFieldLeftPadding * 2.0f),CGRectGetHeight(self.bounds)};

    if (_icon)
    {
        CGFloat addedXCoord = CGRectGetMaxX(self.iconFrame);
        frame.origin.x += addedXCoord;
        frame.size.width -= addedXCoord;
    }

    return frame;
}

-(void)setTextFieldLeftPadding:(CGFloat)textFieldLeftPadding
{
    if (_textFieldLeftPadding == textFieldLeftPadding)
        return;

    _textFieldLeftPadding = textFieldLeftPadding;

    [self setNeedsLayout];
}

#pragma mark - Label methods
-(CGRect)labelFrame
{
    return (CGRect){_labelLeftPadding,0,CGRectGetWidth(self.bounds) - _labelLeftPadding,CGRectGetHeight(self.frame)};
}

-(void)addLabel
{
    if (_label)
    {
        RUDLog(@"already have label");
    }
    else
    {
        _label = [UILabel new];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
    }
}

#pragma mark - Switcher methods
-(CGRect)switcherFrame
{
    CGSize size = [_switcher sizeThatFits:CGSizeZero];
    return (CGRect){CGRectGetWidth(self.bounds) - self.switcherRightPadding - size.width,floorf((CGRectGetHeight(self.bounds) - size.height) / 2.0f),size};
}

-(void)addSwitcher
{
    if (_switcher)
    {
        RUDLog(@"already have switcher");
    }
    else
    {
        _switcher = [UISwitch new];
        [self addSubview:_switcher];
    }
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




//@implementation RUCornerRoundingBorderedView (TextField)
//
//-(void)layoutInputTextField
//{
//    if (self.inputTextField)
//        [self.inputTextField setFrame:self.inputTextFieldFrame];
//}
//
//#pragma mark - Public methods
//-(void)addInputTextField
//{
//    if (self.inputTextField)
//    {
//        RUDLog(@"already have one");
//    }
//    else
//    {
//        UITextField* inputTextField = [UITextField new];
//        [inputTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//        [inputTextField setReturnKeyType:UIReturnKeyNext];
//        [inputTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//        [self addSubview:inputTextField];
//        [self setInputTextField:inputTextField];
//    }
//}
//
//#pragma mark - Getter methods
//-(CGRect)inputTextFieldFrame
//{
//    UITextField* currentTextField = self.inputTextField;
//    CGSize size = (CGSize){CGRectGetWidth(self.bounds) - (CGRectGetMinX(currentTextField.frame) * 2.0f),CGRectGetHeight(self.bounds)};
//    return CGRectSetSize(size, currentTextField.frame);
//}
//
//-(UITextField *)inputTextField
//{
//    return objc_getAssociatedObject(self, &kRUCornerRoundingBorderedViewTextFieldObservingKey);
//}
//
//#pragma mark - Setter methods
//-(void)setTextFieldHorizontalPadding:(CGFloat)textFieldHorizontalPadding
//{
//    UITextField* currentTextField = self.inputTextField;
//    if (currentTextField)
//    {
//        [currentTextField setFrame:CGRectSetX(textFieldHorizontalPadding, currentTextField.frame)];
//    }
//    else
//    {
//        RUDLog(@"need to add the input text field first");
//    }
//}
//
//-(void)setInputTextField:(UITextField *)inputTextField
//{
//    [self willChangeValueForKey:kRUCornerRoundingBorderedViewTextFieldObservingKey];
//    objc_setAssociatedObject(self, &kRUCornerRoundingBorderedViewTextFieldObservingKey,
//                             inputTextField,
//                             OBJC_ASSOCIATION_ASSIGN);
//    [self didChangeValueForKey:kRUCornerRoundingBorderedViewTextFieldObservingKey];
//}
//
//@end
//
//
//
//
