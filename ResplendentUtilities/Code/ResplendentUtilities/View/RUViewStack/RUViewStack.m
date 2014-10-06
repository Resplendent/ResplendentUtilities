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
#import "RUProtocolOrNil.h"





@interface RUViewStack ()

@property (nonatomic, assign) BOOL isAnimating;

-(CGRect)visibleViewFrameForView:(UIView<RUViewStackProtocol>*)view;
-(CGRect)poppedOffViewFrameForView:(UIView<RUViewStackProtocol>*)view;
-(CGRect)pushedOnViewFrameForView:(UIView<RUViewStackProtocol>*)view;

@end





@implementation RUViewStack

#pragma mark - RUViewStack
-(instancetype)initWithRootView:(UIView<RUViewStackProtocol> *)rootView
{
	kRUConditionalReturn_ReturnValueNil(kRUProtocolOrNil(rootView, RUViewStackProtocol), YES);

	if (self = [super init])
	{
		[self setViewStack:@[rootView]];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	UIView<RUViewStackProtocol>* currentlyVisibleView = self.currentlyVisibleView;
	if (currentlyVisibleView)
	{
		[currentlyVisibleView setFrame:[self visibleViewFrameForView:currentlyVisibleView]];
	}
}

#pragma mark - Stack management
-(void)pushViewToStack:(UIView<RUViewStackProtocol> *)view animated:(BOOL)animated
{
	kRUConditionalReturn(kRUProtocolOrNil(view, RUViewStackProtocol), YES);

	NSMutableArray* newViewStack = [NSMutableArray arrayWithArray:self.viewStack];
	[newViewStack addObject:view];
	[self setViewStack:newViewStack animated:animated];
}

-(void)popTopViewFromStackAnimated:(BOOL)animated
{
	NSMutableArray* newViewStack = [NSMutableArray arrayWithArray:self.viewStack];
	kRUConditionalReturn(newViewStack.count == 0, YES);

	[newViewStack removeLastObject];
	[self setViewStack:newViewStack animated:animated];
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

	for (UIView<RUViewStackProtocol>* view in viewStack)
	{
		kRUConditionalReturn(kRUProtocolOrNil(view, RUViewStackProtocol), YES);
		[view setViewStack:self];
	}

	UIView<RUViewStackProtocol>* oldCurrentlyVisibleView = self.currentlyVisibleView;

	_viewStack = [viewStack copy];

	UIView<RUViewStackProtocol>* newCurrentlyVisibleView = self.currentlyVisibleView;

	[self layoutIfNeeded];

	if (oldCurrentlyVisibleView)
	{
		[oldCurrentlyVisibleView setFrame:[self visibleViewFrameForView:oldCurrentlyVisibleView]];
	}

	if (newCurrentlyVisibleView)
	{
		[newCurrentlyVisibleView setFrame:[self pushedOnViewFrameForView:newCurrentlyVisibleView]];
	}

	void (^setFinalFramesBlock)() = ^{
		
		if (oldCurrentlyVisibleView)
		{
			[oldCurrentlyVisibleView setFrame:[self poppedOffViewFrameForView:oldCurrentlyVisibleView]];
		}
		
		if (newCurrentlyVisibleView)
		{
			[newCurrentlyVisibleView setFrame:[self visibleViewFrameForView:newCurrentlyVisibleView]];
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
-(UIView<RUViewStackProtocol> *)currentlyVisibleView
{
	return self.viewStack.lastObject;
}

#pragma mark - Frames
-(CGRect)visibleViewFrameForView:(UIView<RUViewStackProtocol>*)view
{
	CGSize viewSize = view.viewSize;
	return CGRectCeilOrigin((CGRect){
		.origin.x = CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(viewSize.width, CGRectGetWidth(self.bounds)),
		.origin.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(viewSize.width, CGRectGetWidth(self.bounds)),
		.size = viewSize,
	});
}

-(CGRect)poppedOffViewFrameForView:(UIView<RUViewStackProtocol>*)view
{
	CGRect visibleViewFrame = [self visibleViewFrameForView:view];
	return UIEdgeInsetsInsetRect(visibleViewFrame, (UIEdgeInsets){
		
		.left = -CGRectGetWidth(self.bounds),
		
	});
}

-(CGRect)pushedOnViewFrameForView:(UIView<RUViewStackProtocol>*)view
{
	CGRect visibleViewFrame = [self visibleViewFrameForView:view];
	return UIEdgeInsetsInsetRect(visibleViewFrame, (UIEdgeInsets){
		
		.left = CGRectGetWidth(self.bounds),
		
	});
}

@end
