//
//  PAContentModalView.m
//  Resplendent
//
//  Created by Benjamin Maer on 7/29/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUTopBottomBarModalView.h"
#import "UIView+RUUtility.h"
#import "RUConstants.h"
#import "RUGradientButton.h"
#import "RUDLog.h"

#import <QuartzCore/CALayer.h>





CGFloat const kPAContentModalViewTopBarHeight = 50.0f;
CGFloat const kPAContentModalViewTopBarButtonHeight = 30.0f;

CGFloat const kPAContentModalViewBottomBarHeight = 50.0f;
CGFloat const kPAContentModalViewBottomBarButtonHeight = 30.0f;





@interface RUTopBottomBarModalView ()

@property (nonatomic, readonly) Class _topBarLabelClass;
@property (nonatomic, readonly) Class _bottomBarLabelClass;

@end





@implementation RUTopBottomBarModalView

#pragma mark - UIView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.tapGestureRecognizer setDelegate:self];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

	//Top Bar
    if (self.topBar)
    {
        [self.topBar setFrame:self.topBarFrame];
    }

	if (self.topBarUnderline)
	{
		[self.topBarUnderline setFrame:self.topBarUnderlineFrame];
	}

    if (self.topBarButton)
	{
		[self.topBarButton setFrame:self.topBarButtonFrame];
	}

	if (self.topBarLabel)
	{
		[self.topBarLabel setFrame:self.topBarLabelFrame];
	}

	//Bottom Bar
    if (self.bottomBar)
    {
        [self.bottomBar setFrame:self.bottomBarFrame];
    }

	if (self.bottomBarOverline)
	{
		[self.bottomBarOverline setFrame:self.bottomBarOverlineFrame];
	}

	if (self.bottomBarButton)
	{
		[self.bottomBarButton setFrame:self.bottomBarButtonFrame];
	}
	
	if (self.bottomBarLabel)
	{
		[self.bottomBarLabel setFrame:self.bottomBarLabelFrame];
	}
}

#pragma mark - Classes
-(Class)_topBarLabelClass
{
	return (self.topBarLabelClass ?: [UILabel class]);
}

-(Class)_bottomBarLabelClass
{
	return (self.bottomBarLabelClass ?: [UILabel class]);
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
            [self.contentView addSubview:self.topBar];
            [self setNeedsLayout];
        }
        
        if (!_topBarLabel)
        {
            _topBarLabel = [self._topBarLabelClass new];
            [_topBarLabel setText:@"Bookmark Privacy"];
            [_topBarLabel setTextColor:[UIColor blackColor]];
            [_topBarLabel setBackgroundColor:[UIColor clearColor]];
            [_topBar addSubview:_topBarLabel];
        }
        
        if (!_topBarButton)
        {
            _topBarButton = [RUGradientButton buttonWithType:UIButtonTypeCustom];
            [_topBarButton addTarget:self action:@selector(pressedTopBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:_topBarButton];
        }
        
        if (!_topBarUnderline)
        {
            _topBarUnderline = [UIView new];
            [_topBar addSubview:_topBarUnderline];
        }

		[self setNeedsLayout];
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
    CGFloat contentViewHorizontalInnerPadding = self.contentViewHorizontalInnerPadding;
    return (CGRect){contentViewHorizontalInnerPadding,0,self.topBarLabelRightBoundary - contentViewHorizontalInnerPadding,self.topBarHeight};
}

-(CGFloat)topBarLabelRightBoundary
{
    return CGRectGetMinX(self.topBarButtonFrame);
}

-(CGRect)topBarButtonFrame
{
    CGFloat topBarButtonWidth = self.topBarButtonWidth;
    return (CGRect){
        .origin.x = CGRectGetWidth(self.contentViewFrame) - topBarButtonWidth - self.contentViewHorizontalInnerPadding,
        .origin.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(kPAContentModalViewTopBarButtonHeight, self.topBarHeight),
        .size.width = topBarButtonWidth,
		.size.height = kPAContentModalViewTopBarButtonHeight
    };
}

-(CGFloat)topBarButtonWidth
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGRect)topBarUnderlineFrame
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
            [self.contentView addSubview:self.bottomBar];
            [self setNeedsLayout];
        }
        
        if (!_bottomBarLabel)
        {
            _bottomBarLabel = [self.bottomBarLabelClass new];
            [_bottomBarLabel setText:@"Bookmark Privacy"];
            [_bottomBarLabel setTextColor:[UIColor blackColor]];
            [_bottomBarLabel setBackgroundColor:[UIColor clearColor]];
            [_bottomBar addSubview:_bottomBarLabel];
        }
        
        if (!_bottomBarButton)
        {
            _bottomBarButton = [RUGradientButton buttonWithType:UIButtonTypeCustom];
            [_bottomBarButton addTarget:self action:@selector(pressedBottomBarButton:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomBar addSubview:_bottomBarButton];
        }
        
        if (!_bottomBarOverline)
        {
            _bottomBarOverline = [UIView new];
            [_bottomBar addSubview:_bottomBarOverline];
        }

		[self setNeedsLayout];
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
    CGFloat contentViewHorizontalInnerPadding = self.contentViewHorizontalInnerPadding;
    return (CGRect){contentViewHorizontalInnerPadding,0,self.bottomBarLabelRightBoundary - contentViewHorizontalInnerPadding,self.bottomBarHeight};
}

-(CGFloat)bottomBarLabelRightBoundary
{
    return CGRectGetMinX(self.bottomBarButtonFrame);
}

-(CGRect)bottomBarButtonFrame
{
    CGFloat bottomBarButtonWidth = self.bottomBarButtonWidth;
    return (CGRect){
        CGRectGetWidth(self.contentViewFrame) - bottomBarButtonWidth - self.contentViewHorizontalInnerPadding,
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

#pragma mark - Frames
-(CGFloat)contentViewHorizontalInnerPadding
{
    return 10;
}

#pragma mark - RUModalView Frames
-(CGRect)innerContentViewFrame
{
	CGRect innerContentViewFrame = [super innerContentViewFrame];

	CGFloat bottom = (self.bottomBar ? CGRectGetMinY(self.bottomBarFrame) : CGRectGetMaxY(innerContentViewFrame));

    if (self.topBar)
    {
		innerContentViewFrame.origin.y = CGRectGetMaxY(self.topBarFrame);
    }

	innerContentViewFrame.size.height = bottom - CGRectGetMinY(innerContentViewFrame);

	return innerContentViewFrame;
}

@end
