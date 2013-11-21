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

@synthesize titleLabel = _titleLabel;

-(id)init
{
    return ([self initWithFrame:(CGRect){0, 0, [self sizeThatFits:CGSizeZero]}]);
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

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGRect animatableContentViewFrame = self.animatableContentViewFrame;
    [_animatableContentView setFrame:animatableContentViewFrame];

    if (_leftButton)
    {
        [_leftButton setFrame:[self leftButtonFrameWithAnimatableContentViewFrame:animatableContentViewFrame]];
    }
    
    if (_rightButton)
    {
        [_rightButton setFrame:[self rightButtonFrameWithAnimatableContentViewFrame:animatableContentViewFrame]];
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

-(CGSize)sizeThatFits:(CGSize)size
{
    return (CGSize){CGRectGetWidth([UIScreen mainScreen].bounds), self.height};
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

#pragma mark - Frames
-(CGRect)leftButtonFrameWithAnimatableContentViewFrame:(CGRect)animatableContentViewFrame
{
    CGSize size = _leftButton.frame.size;
    CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(size.height, CGRectGetHeight(animatableContentViewFrame));
    return (CGRect){(self.leftButtonLeftPadding ? self.leftButtonLeftPadding.floatValue : yCoord),yCoord,size};
}

-(CGRect)rightButtonFrameWithAnimatableContentViewFrame:(CGRect)animatableContentViewFrame
{
    CGSize size = _rightButton.frame.size;
    CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(size.height, CGRectGetHeight(animatableContentViewFrame));
    return (CGRect){ceil(CGRectGetWidth(animatableContentViewFrame) - size.width - (self.rightButtonRightPadding ? self.rightButtonRightPadding.floatValue : yCoord)),yCoord,size};
}

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

-(CGRect)animatableContentViewFrame
{
    return CGRectSetSize(CGSizeMake(CGRectGetWidth(self.frame),self.animatableContentViewHeight), _animatableContentView.frame);
}

-(CGRect)titleLabelFrame
{
    CGFloat width = [_titleLabel.text sizeWithFont:_titleLabel.font].width;
    return (CGRect){CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(width, CGRectGetWidth(self.frame)),self.titleLabelTopEdgeInset,width,self.animatableContentViewHeight - self.titleLabelTopEdgeInset};
}

#pragma mark - Getters
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
