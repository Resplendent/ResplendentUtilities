//
//  RUCredentialInputView.m
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCredentialInputView.h"

//@interface RUCredentialInputView ()
//
//@property (nonatomic, strong) UILabel* textLabel;
//
//@end




@implementation RUCredentialInputView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
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
}

-(BOOL)becomeFirstResponder
{
    return [_inputTextField becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    return [_inputTextField resignFirstResponder];
}

#pragma mark - Setter methods
#pragma mark - Getter methods
-(CGRect)inputTextFieldFrame
{
    return (CGRect){_textFieldHorizontalPadding,0,CGRectGetWidth(self.bounds) - _textFieldHorizontalPadding,CGRectGetHeight(self.bounds)};
}

@end

