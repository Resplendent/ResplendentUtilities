//
//  PAContentModalView.m
//  Pineapple
//
//  Created by Benjamin Maer on 7/29/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUContentModalView.h"

#import "RUGradientButton+Pineapple.h"
#import "UIFont+RUConstants.h"
#import <QuartzCore/CALayer.h>

CGFloat const kPAContentModalViewContentViewWidth = 300.0f;

CGFloat const kPAContentModalViewTopBarHeight = 50.0f;
CGFloat const kPAContentModalViewTopBarButtonHeight = 30.0f;

CGFloat const kPAContentModalViewBottomBarHeight = 50.0f;
CGFloat const kPAContentModalViewBottomBarButtonHeight = 30.0f;

CGFloat const kPAContentModalViewContentViewInnerHorizontalPadding = 10.0f;


@implementation RUContentModalView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.tapGestureRecognizer setDelegate:self];

        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:5.0f];
        [_contentView setClipsToBounds:YES];
        [self addSubview:_contentView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_contentView setFrame:self.contentViewFrame];
    
    if (_topBar)
    {
        [_topBar setFrame:self.topBarFrame];
    }
    
    if (_bottomBar)
    {
        [_bottomBar setFrame:self.bottomBarFrame];
    }
}

#pragma mark - Content View
-(CGRect)contentViewFrame
{
    return (CGRect){
        CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(kPAContentModalViewContentViewWidth, CGRectGetWidth(self.bounds)),
        self.contentViewYCoord,kPAContentModalViewContentViewWidth,self.contentViewHeight
    };
}

-(CGFloat)contentViewYCoord
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGFloat)contentViewHeight
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGFloat)contentViewInnerPadding
{
    return kPAContentModalViewContentViewInnerHorizontalPadding;
}

-(CGRect)innerContentViewFrame
{
    CGFloat yCoord = 0;
    
    if (_topBar)
    {
        yCoord = CGRectGetMaxY(self.topBarFrame);
    }
    
    CGRect contentViewFrame = self.contentViewFrame;
    CGFloat height = (_bottomBar ? CGRectGetMinY(self.bottomBarFrame) : CGRectGetHeight(contentViewFrame)) - yCoord;
    
    //    if (_bottomBar)
    //    {
    //        height -=
    //    }
    ////    CGRect topBarUnderLineFrame = self.topBarUnderLineFrame;
    //    CGFloat yCoord = CGRectGetMaxY(topBarUnderLineFrame);
    return (CGRect){0,yCoord,CGRectGetWidth(contentViewFrame),height};
}

#pragma mark - Top Bar
-(BOOL)enableTopBar
{
    return (_topBar != nil &&
            _topBarButton != nil &&
            _topBarLabel != nil &&
            _topBarUnderline != nil);
}

-(void)setEnableTopBar:(BOOL)enableTopBar
{
    if (self.enableTopBar == enableTopBar)
        return;
    
    if (enableTopBar)
    {
        if (!_topBar)
        {
            _topBar = [UIView new];
            [_topBar setBackgroundColor:[UIColor paTopBarGrayColor]];
            [_contentView addSubview:_topBar];
            [self setNeedsLayout];
        }
        
        if (!_topBarLabel)
        {
            _topBarLabel = [[self.topBarLabelClass alloc]initWithFrame:self.topBarLabelFrame];
            [_topBarLabel setFont:kRUFontWithHelvetica(YES, 16.0f)];
            [_topBarLabel setText:@"Bookmark Privacy"];
            [_topBarLabel setTextColor:[UIColor blackColor]];
            [_topBarLabel setBackgroundColor:[UIColor clearColor]];
            [_topBar addSubview:_topBarLabel];
        }
        
        if (!_topBarButton)
        {
            _topBarButton = [RUGradientButton paGrayGradientButton];
            [_topBarButton setFrame:self.topBarButtonFrame];
            [_topBarButton addTarget:self action:@selector(pressedTopBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:_topBarButton];
        }
        
        if (!_topBarUnderline)
        {
            _topBarUnderline = [[UIView alloc] initWithFrame:self.topBarUnderLineFrame];
            [_topBarUnderline setBackgroundColor:[UIColor paTopBarUnderlineGrayColor]];
            [_topBar addSubview:_topBarUnderline];
        }
    }
    else
    {
        if (_topBarUnderline)
        {
            [_topBarUnderline removeFromSuperview];
            _topBarUnderline = nil;
        }
        
        if (_topBarButton)
        {
            [_topBarButton removeFromSuperview];
            _topBarButton = nil;
        }
        
        if (_topBarLabel)
        {
            [_topBarLabel removeFromSuperview];
            _topBarLabel = nil;
        }
        
        if (_topBar)
        {
            [_topBar removeFromSuperview];
            _topBar = nil;
        }
    }
}

-(Class)topBarButtonClass
{
    return [UILabel class];
}

-(CGRect)topBarFrame
{
    return (CGRect){0,0,CGRectGetWidth(self.contentViewFrame),self.topBarHeight};
}

-(CGFloat)topBarHeight
{
    return kPAContentModalViewTopBarHeight;
}

-(CGRect)topBarLabelFrame
{
    CGFloat contentViewInnerPadding = self.contentViewInnerPadding;
    return (CGRect){contentViewInnerPadding,0,self.topBarLabelRightBoundary - contentViewInnerPadding,self.topBarHeight};
}

-(CGFloat)topBarLabelRightBoundary
{
    return CGRectGetMinX(self.topBarButtonFrame);
}

-(CGRect)topBarButtonFrame
{
    CGFloat topBarButtonWidth = self.topBarButtonWidth;
    //    CGFloat contentViewHeight = self.contentViewHeight;
    //    CGFloat contentViewInnerPadding = self.contentViewInnerPadding;
    return (CGRect){
        CGRectGetWidth(self.contentViewFrame) - topBarButtonWidth - self.contentViewInnerPadding,
        CGRectGetVerticallyAlignedYCoordForHeightOnHeight(kPAContentModalViewTopBarButtonHeight, self.topBarHeight),
        topBarButtonWidth,kPAContentModalViewTopBarButtonHeight
    };
}

-(CGFloat)topBarButtonWidth
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGRect)topBarUnderLineFrame
{
    CGRect topBarFrame = self.topBarFrame;
    return (CGRect){0,CGRectGetHeight(topBarFrame) - 1.0f,CGRectGetWidth(topBarFrame),1.0f};
}

-(void)pressedTopBarButton:(UIButton*)button
{
    RU_METHOD_IMPLEMENTATION_NEEDED;
}

#pragma mark - Bottom Bar
-(BOOL)enableBottomBar
{
    return (_bottomBar != nil &&
            _bottomBarButton != nil &&
            _bottomBarLabel != nil &&
            _bottomBarOverline != nil);
}

-(void)setEnableBottomBar:(BOOL)enableBottomBar
{
    if (self.enableBottomBar == enableBottomBar)
        return;
    
    if (enableBottomBar)
    {
        if (!_bottomBar)
        {
            _bottomBar = [UIView new];
            [_bottomBar setBackgroundColor:[UIColor paTopBarGrayColor]];
            [_contentView addSubview:_bottomBar];
            [self setNeedsLayout];
        }
        
        if (!_bottomBarLabel)
        {
            _bottomBarLabel = [[self.bottomBarLabelClass alloc]initWithFrame:self.bottomBarLabelFrame];
            [_bottomBarLabel setFont:kRUFontWithHelvetica(YES, 16.0f)];
            [_bottomBarLabel setText:@"Bookmark Privacy"];
            [_bottomBarLabel setTextColor:[UIColor blackColor]];
            [_bottomBarLabel setBackgroundColor:[UIColor clearColor]];
            [_bottomBar addSubview:_bottomBarLabel];
        }
        
        if (!_bottomBarButton)
        {
            _bottomBarButton = [RUGradientButton paTealGradientButton];
            [_bottomBarButton setFrame:self.bottomBarButtonFrame];
            [_bottomBarButton addTarget:self action:@selector(pressedBottomBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomBar addSubview:_bottomBarButton];
        }
        
        if (!_bottomBarOverline)
        {
            _bottomBarOverline = [[UIView alloc] initWithFrame:self.bottomBarOverlineFrame];
            [_bottomBarOverline setBackgroundColor:[UIColor paTopBarUnderlineGrayColor]];
            [_bottomBar addSubview:_bottomBarOverline];
        }
    }
    else
    {
        if (_bottomBarOverline)
        {
            [_bottomBarOverline removeFromSuperview];
            _bottomBarOverline = nil;
        }
        
        if (_bottomBarButton)
        {
            [_bottomBarButton removeFromSuperview];
            _bottomBarButton = nil;
        }
        
        if (_bottomBarLabel)
        {
            [_bottomBarLabel removeFromSuperview];
            _bottomBarLabel = nil;
        }
        
        if (_bottomBar)
        {
            [_bottomBar removeFromSuperview];
            _bottomBar = nil;
        }
    }
}

-(Class)bottomBarButtonClass
{
    return [UILabel class];
}

-(CGRect)bottomBarFrame
{
    CGRect contentViewFrame = self.contentViewFrame;
    CGFloat bottomBarHeight = self.bottomBarHeight;
    return (CGRect){0,CGRectGetHeight(contentViewFrame) - bottomBarHeight,CGRectGetWidth(contentViewFrame),bottomBarHeight};
}

-(CGFloat)bottomBarHeight
{
    return kPAContentModalViewBottomBarHeight;
}

-(CGRect)bottomBarLabelFrame
{
    CGFloat contentViewInnerPadding = self.contentViewInnerPadding;
    return (CGRect){contentViewInnerPadding,0,self.bottomBarLabelRightBoundary - contentViewInnerPadding,self.bottomBarHeight};
}

-(CGFloat)bottomBarLabelRightBoundary
{
    return CGRectGetMinX(self.bottomBarButtonFrame);
}

-(CGRect)bottomBarButtonFrame
{
    CGFloat bottomBarButtonWidth = self.bottomBarButtonWidth;
    return (CGRect){
        CGRectGetWidth(self.contentViewFrame) - bottomBarButtonWidth - self.contentViewInnerPadding,
        CGRectGetVerticallyAlignedYCoordForHeightOnHeight(kPAContentModalViewBottomBarButtonHeight, self.bottomBarHeight),
        bottomBarButtonWidth,kPAContentModalViewBottomBarButtonHeight
    };
}

-(CGFloat)bottomBarButtonWidth
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGRect)bottomBarOverlineFrame
{
    return (CGRect){0,0,CGRectGetWidth(self.bottomBarFrame),1.0f};
}

-(void)pressedBottomBarButton:(UIButton*)button
{
    RU_METHOD_IMPLEMENTATION_NEEDED;
}

#pragma mark - UIGestureRecognizerDelegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return !CGRectContainsPoint(self.contentViewFrame, [touch locationInView:self]);
}

@end
