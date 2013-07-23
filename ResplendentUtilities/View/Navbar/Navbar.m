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

-(CGRect)animatableContentViewFrame
{
    return CGRectSetSize(CGSizeMake(CGRectGetWidth(self.frame),self.animatableContentViewHeight), _animatableContentView.frame);
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_animatableContentView setFrame:self.animatableContentViewFrame];

    if (_autoAdjustButtons)
    {
        if (_leftButton)
        {
            CGSize size = _leftButton.frame.size;
            CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(size.height, CGRectGetHeight(self.frame) - self.animatableContentViewLowerPadding);
            [_leftButton setFrame:(CGRect){(self.leftButtonLeftPadding ? self.leftButtonLeftPadding.floatValue : yCoord),yCoord,size}];
        }

        if (_rightButton)
        {
            CGSize size = _rightButton.frame.size;
            CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(size.height, CGRectGetHeight(self.frame) - self.animatableContentViewLowerPadding);
            [_rightButton setFrame:(CGRect){ceil(CGRectGetWidth(self.frame) - size.width - (self.rightButtonRightPadding ? self.rightButtonRightPadding.floatValue : yCoord)),yCoord,size}];
        }
    }

    if (_titleLabel)
    {
        [_titleLabel setFrame:self.titleLabelFrame];
    }
}

-(void)dealloc
{
    if (_titleLabel)
    {
        [_titleLabel removeObserver:self forKeyPath:@"text"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _titleLabel)
    {
        if ([keyPath isEqualToString:@"text"])
        {
            [self setNeedsLayout];
        }
        else
        {
            RUDLog(@"unhandled keypath %@ for object %@",keyPath,object);
        }
    }
    else
    {
        RUDLog(@"unhandled object %@",object);
    }
}

#pragma mark - Setters
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

#pragma mark - Getters
-(CGFloat)animatableContentViewHeight
{
    return (CGRectGetHeight(self.frame) - self.animatableContentViewLowerPadding);
}

-(CGFloat)height
{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

-(CGFloat)animatableContentViewLowerPadding
{
    return 0.0f;
}

-(CGRect)titleLabelFrame
{
    CGFloat width = [_titleLabel.text sizeWithFont:_titleLabel.font].width;
    return (CGRect){CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(width, CGRectGetWidth(self.frame)),self.titleLabelTopEdgeInset,width,self.animatableContentViewHeight - self.titleLabelTopEdgeInset};
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
        [_titleLabel addObserver:self forKeyPath:@"text" options:0 context:nil];
        [self setNeedsLayout];
    }

    return _titleLabel;
}

@end
