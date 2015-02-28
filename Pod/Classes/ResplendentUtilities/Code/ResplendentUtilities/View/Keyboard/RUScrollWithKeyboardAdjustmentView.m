//
//  RUScrollWithKeyboardAdjustmentView.m
//  Resplendent
//
//  Created by Benjamin Maer on 12/21/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUScrollWithKeyboardAdjustmentView.h"
#import "RUKeyboardAdjustmentHelper.h"
#import "UIView+RUEnableTapToResignFirstResponder.h"
#import "UIView+RUSubviews.h"
#import "RUClassOrNilUtil.h"





@interface RUScrollWithKeyboardAdjustmentView ()

@property (nonatomic, readonly) CGRect scrollViewFrame;
@property (nonatomic, readonly) CGFloat scrollViewKeyboardBottomPadding;

@end






@implementation RUScrollWithKeyboardAdjustmentView

#pragma mark - NSObject
-(id)forwardingTargetForSelector:(SEL)aSelector
{
	return self.scrollView;
}

#pragma mark - RUScrollWithKeyboardAdjustmentView
-(id)initWithScrollView:(UIScrollView*)scrollView
{
	if (kRUClassOrNil(scrollView, UIScrollView) == FALSE)
	{
		NSAssert(FALSE, @"Must pass a scroll view");
		return nil;
	}

	_scrollView = scrollView;

	return (self = [self init]);
}

#pragma mark - UIView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		if (self.scrollView == nil)
		{
			_scrollView = [UIScrollView new];
			[_scrollView setBackgroundColor:[UIColor clearColor]];
			[_scrollView setShowsVerticalScrollIndicator:NO];
		}

        [self addSubview:_scrollView];
        
        _keyboardHelper = [RUKeyboardAdjustmentHelper new];
        [_keyboardHelper setDelegate:self];
        [_keyboardHelper setRegisteredForKeyboardNotifications:YES];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_scrollView setFrame:self.scrollViewFrame];

	if (kRUClassOrNil(self.scrollView, UITableView) == FALSE)
	{
		[self.scrollView setContentSize:self.scrollViewContentSize];
	}
}

#pragma mark - Public
-(void)addSubviewToScrollView:(UIView*)view
{
    NSAssert(view != nil, @"view must be non-nil");
    [_scrollView addSubview:view];
    [self setNeedsLayout];
}

#pragma mark - Frames
-(CGRect)scrollViewFrame
{
    CGRect scrollViewFrame = self.bounds;
    
    scrollViewFrame.size.height -= self.scrollViewKeyboardBottomPadding;
    
    return scrollViewFrame;
}

-(CGFloat)scrollViewKeyboardBottomPadding
{
    if (_keyboardHelper.keyboardTop)
    {
        UIView* relativeView = [UIApplication sharedApplication].keyWindow;
        CGRect frameInWindow = [self.superview convertRect:self.frame toView:relativeView];
        CGFloat bottom = CGRectGetMaxY(frameInWindow);
        CGFloat yOffset = CGRectGetHeight(relativeView.frame) - bottom;
        
        return _keyboardHelper.keyboardTop.floatValue - yOffset;
    }
    else
    {
        return 0;
    }
}

-(CGSize)scrollViewContentSize
{
    return (CGSize){CGRectGetWidth(self.bounds),self.scrollViewContentSizeHeight};
}

-(CGFloat)scrollViewContentSizeHeight
{
    return CGRectGetMaxY(self.scrollView.ruLowestSubview.frame) + self.scrollViewBottomPadding;
}

#pragma mark - disableKeyboardAdjustment
-(BOOL)disableKeyboardAdjustment
{
	return (_keyboardHelper.delegate == self);
}

-(void)setDisableKeyboardAdjustment:(BOOL)disableKeyboardAdjustment
{
	if (self.disableKeyboardAdjustment == disableKeyboardAdjustment)
		return;

	[_keyboardHelper setDelegate:(disableKeyboardAdjustment ? self : nil)];
}

#pragma mark - RUKeyboardAdjustmentHelperDelegate
-(void)keyboardAdjustmentHelper:(RUKeyboardAdjustmentHelper *)keyboardAdjustmentHelper willShowWithAnimationDuration:(NSTimeInterval)animationDuration
{
	[self layoutIfNeeded];
	[UIView animateWithDuration:animationDuration animations:^{
		[self layoutSubviews];
		
	} completion:^(BOOL finished) {
		UIView* ruSelfOrSubviewFirstResponder = self.ruSelfOrSubviewFirstResponder;
		if (ruSelfOrSubviewFirstResponder)
		{
			CGRect convertedFrame = [self.scrollView convertRect:ruSelfOrSubviewFirstResponder.bounds fromView:ruSelfOrSubviewFirstResponder];
			CGRect scrollToFrame = convertedFrame;
			scrollToFrame.origin.y += self.scrollViewBottomKeyboardPadding;
			[self.scrollView scrollRectToVisible:scrollToFrame animated:YES];
		}
	}];
}

-(void)keyboardAdjustmentHelper:(RUKeyboardAdjustmentHelper *)keyboardAdjustmentHelper willHideWithAnimationDuration:(NSTimeInterval)animationDuration
{
	[UIView animateWithDuration:animationDuration animations:^{
		[self layoutSubviews];
	}];
}

@end
