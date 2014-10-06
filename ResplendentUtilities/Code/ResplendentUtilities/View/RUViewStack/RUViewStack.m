//
//  RUViewStack.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/5/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RUViewStack.h"
#import "RUConditionalReturn.h"
#import "UIView+RUUtility.h"





@interface RUViewStack ()

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, readonly) CGRect visibleViewFrame;
@property (nonatomic, readonly) CGRect poppedOffViewFrame;
@property (nonatomic, readonly) CGRect pushedOnViewFrame;

@end





@implementation RUViewStack

#pragma mark - RUViewStack
-(instancetype)initWithRootView:(UIView *)rootView
{
	if (self = [super init])
	{
		[self setViewStack:@[rootView]];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	UIView* currentlyVisibleView = self.currentlyVisibleView;
	if (currentlyVisibleView)
	{
		[currentlyVisibleView setFrame:self.visibleViewFrame];
	}
}

#pragma mark - Stack management
-(void)pushViewToStack:(UIView*)view animated:(BOOL)animated
{
	
}

-(void)popTopViewFromStackAnimated:(BOOL)animated
{
	
}

#pragma mark - Setters
-(void)setViewStack:(NSArray *)viewStack
{
	[self setViewStack:viewStack animated:NO];
}

-(void)setViewStack:(NSArray *)viewStack animated:(BOOL)animated
{
	kRUConditionalReturn(self.isAnimating, YES);
	kRUConditionalReturn(self.viewStack == viewStack, NO);

	UIView* oldCurrentlyVisibleView = self.currentlyVisibleView;

	_viewStack = [viewStack copy];

	UIView* newCurrentlyVisibleView = self.currentlyVisibleView;

	[self layoutIfNeeded];

	if (oldCurrentlyVisibleView)
	{
		[oldCurrentlyVisibleView setFrame:self.visibleViewFrame];
	}

	if (newCurrentlyVisibleView)
	{
		[newCurrentlyVisibleView setFrame:self.pushedOnViewFrame];
	}

	void (^setFinalFramesBlock)() = ^{
		
		if (oldCurrentlyVisibleView)
		{
			[oldCurrentlyVisibleView setFrame:self.poppedOffViewFrame];
		}
		
		if (newCurrentlyVisibleView)
		{
			[newCurrentlyVisibleView setFrame:self.visibleViewFrame];
		}

	};

	if (animated)
	{
		[self setIsAnimating:YES];

		[UIView animateWithDuration:0.25f animations:^{

			setFinalFramesBlock();

		} completion:^(BOOL finished) {

			[self setIsAnimating:NO];

		}];
	}
	else
	{
		setFinalFramesBlock();
	}
}

#pragma mark - currentlyVisibleView
-(CGRect)visibleViewFrame
{
	return self.bounds;
}

-(CGRect)poppedOffViewFrame
{
	CGRect visibleViewFrame = self.visibleViewFrame;
	return UIEdgeInsetsInsetRect(visibleViewFrame, (UIEdgeInsets){
		
		.left = -CGRectGetWidth(self.bounds),
		
	});
}

-(CGRect)pushedOnViewFrame
{
	CGRect visibleViewFrame = self.visibleViewFrame;
	return UIEdgeInsetsInsetRect(visibleViewFrame, (UIEdgeInsets){
		
		.left = CGRectGetWidth(self.bounds),
		
	});
}

@end
