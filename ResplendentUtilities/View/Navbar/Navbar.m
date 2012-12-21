//
//  Navbar.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "Navbar.h"
#import "UIView+Utility.h"

@implementation Navbar

@synthesize autoAdjustButtons = _autoAdjustButtons;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;

@synthesize titleLabel = _titleLabel;

-(id)init
{
    return ([self initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f) autoAdjustButtons:YES]);
}

-(id)initWithFrame:(CGRect)frame autoAdjustButtons:(BOOL)autoAdjustButtons
{
    _autoAdjustButtons = autoAdjustButtons;
    if (self = [super initWithFrame:frame])
    {
        [self setUserInteractionEnabled:YES];

        _animatableContentView = [UIView new];
        [self addSubview:_animatableContentView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_animatableContentView setFrame:self.bounds];

    if (_autoAdjustButtons)
    {
        CGFloat middle = self.frame.size.height / 2.0f;

        [_leftButton setCenter:CGPointMake(MAX(middle, CGRectGetWidth(_leftButton.frame) / 2.0f) + 4.0f, middle)];
        ceilCoordinates(_leftButton);

        [_rightButton setCenter:CGPointMake(self.frame.size.width - MAX(middle, CGRectGetWidth(_rightButton.frame) / 2.0f) - 4.0f, middle)];
        ceilCoordinates(_rightButton);
    }

    [_titleLabel setFrame:CGRectMake(0, _titleLabelTopEdgeInset, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _titleLabelTopEdgeInset)];
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

#pragma mark - Public methods
//-(void)setAlphaForComponents:(CGFloat)alpha
//{
//    [_leftButton setAlpha:alpha];
//    [_rightButton setAlpha:alpha];
//}

#pragma mark - Getter methods
-(NIAttributedLabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[NIAttributedLabel alloc] init];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setVerticalTextAlignment:NIVerticalTextAlignmentMiddle];
        [self addSubview:_titleLabel];
        [self setNeedsLayout];
    }

    return _titleLabel;
}

@end
