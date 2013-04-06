//
//  Navbar.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "Navbar.h"
#import "UIView+Utility.h"
#import "RUConstants.h"

#define kNavbarDefaultButtonHorizontalEdgeInset 0.0f

@implementation Navbar

@synthesize autoAdjustButtons = _autoAdjustButtons;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;

@synthesize titleLabel = _titleLabel;

-(id)init
{
    return ([self initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.height) autoAdjustButtons:YES]);
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _buttonHorizontalEdgeInset = kNavbarDefaultButtonHorizontalEdgeInset;
        _animatableContentView = [UIView new];
        [self addSubview:_animatableContentView];
        [self setUserInteractionEnabled:YES];
    }

    return self;
}

-(id)initWithFrame:(CGRect)frame autoAdjustButtons:(BOOL)autoAdjustButtons
{
    _autoAdjustButtons = autoAdjustButtons;
    return [self initWithFrame:frame];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGSize animatableContentViewSize = self.bounds.size;
    animatableContentViewSize.height -= self.animatableContentViewLowerPadding;
    [_animatableContentView setFrame:CGRectSetSize(animatableContentViewSize, _animatableContentView.frame)];

    if (_autoAdjustButtons)
    {
        if (_leftButton)
        {
            CGFloat leftButtonPadding = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(CGRectGetHeight(_leftButton.frame), CGRectGetHeight(self.animatableContentView.frame));
            [_leftButton setFrame:CGRectSetXY(leftButtonPadding, leftButtonPadding, _leftButton.frame)];
        }
        
        if (_rightButton)
        {
            CGFloat leftButtonPadding = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(CGRectGetHeight(_rightButton.frame), CGRectGetHeight(self.animatableContentView.frame));
            [_rightButton setFrame:CGRectSetXY(leftButtonPadding, leftButtonPadding, _rightButton.frame)];
        }
    }

    [_titleLabel setFrame:CGRectMake(_rightButton.frame.size.width, _titleLabelTopEdgeInset, CGRectGetWidth(self.frame) - (_rightButton.frame.size.width * 2), CGRectGetHeight(_animatableContentView.frame) - _titleLabelTopEdgeInset)];
}

-(void)setLeftButton:(UIButton *)leftButton
{
    if (leftButton == _leftButton)
        return;
    
    [_leftButton removeFromSuperview];
    _leftButton = leftButton;
    [_animatableContentView addSubview:_leftButton];
    [self setNeedsLayout];
}

-(void)setRightButton:(UIButton *)rightButton
{
    if (rightButton == _rightButton)
        return;

    [_rightButton removeFromSuperview];
    _rightButton = rightButton;
    [_rightButton setShowsTouchWhenHighlighted:NO];
    [_animatableContentView addSubview:_rightButton];
    [self setNeedsLayout];
}

#pragma mark - Getter methods
-(CGFloat)height
{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

-(CGFloat)animatableContentViewLowerPadding
{
    return 0.0f;
}

-(NIAttributedLabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[NIAttributedLabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setVerticalTextAlignment:NIVerticalTextAlignmentMiddle];
        [_animatableContentView addSubview:_titleLabel];
        [self setNeedsLayout];
    }

    return _titleLabel;
}

@end
