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
	kRUConditionalReturn_ReturnValueNil(rootView == nil, YES);
	if (self = [super initWithFrame:CGRectZero])
	{
		[self setViewStack:@[rootView]];
	}

	return self;
}

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [self initWithRootView:nil])
	{
		
	}
	
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		
	}
	
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	UIView<RUViewStackProtocol>* currentlyVisibleView = self.currentlyVisibleView;
	if (currentlyVisibleView)
	{
		if (self.isAnimating == false)
		{
			[currentlyVisibleView setFrame:[self visibleViewFrameForView:currentlyVisibleView]];
		}
	}
}

#pragma mark - Stack management
-(void)pushViewToStack:(UIView<RUViewStackProtocol> *)view animated:(BOOL)animated
{
	kRUConditionalReturn(kRUProtocolOrNil(view, RUViewStackProtocol) == false, YES);

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

#pragma mark - viewStack
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
		kRUConditionalReturn(kRUProtocolOrNil(view, RUViewStackProtocol) == false, YES);
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
		[self addSubview:newCurrentlyVisibleView];
		[self layoutIfNeeded];
		[newCurrentlyVisibleView setFrame:[self pushedOnViewFrameForView:newCurrentlyVisibleView]];
	}

	// setFinalFramesBlock
	__weak typeof(self) weak_self = self;
	__weak typeof(oldCurrentlyVisibleView) oldCurrentlyVisibleView_weak = oldCurrentlyVisibleView;
	__weak typeof(newCurrentlyVisibleView) newCurrentlyVisibleView_weak = newCurrentlyVisibleView;
	void (^setFinalFramesBlock)() = ^{
		kRUConditionalReturn(weak_self == nil, NO);
		
		if (oldCurrentlyVisibleView_weak)
		{
			[oldCurrentlyVisibleView_weak setFrame:[weak_self poppedOffViewFrameForView:oldCurrentlyVisibleView_weak]];
		}
		
		if (newCurrentlyVisibleView_weak)
		{
			[newCurrentlyVisibleView_weak setFrame:[weak_self visibleViewFrameForView:newCurrentlyVisibleView_weak]];
		}

	};

	//removeOldCurrentlyVisibleViewBlock
	void (^removeOldCurrentlyVisibleViewBlock)() = ^{

		if (oldCurrentlyVisibleView_weak)
		{
			[oldCurrentlyVisibleView_weak removeFromSuperview];
		}

	};

	if (animated)
	{
		[self setIsAnimating:YES];

		[UIView animateWithDuration:0.25f animations:^{

			setFinalFramesBlock();

		} completion:^(BOOL finished) {

			[weak_self setIsAnimating:NO];
			removeOldCurrentlyVisibleViewBlock();

		}];
	}
	else
	{
		setFinalFramesBlock();
		removeOldCurrentlyVisibleViewBlock();
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

	CGPoint origin = (CGPoint){
		.x = CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(viewSize.width, CGRectGetWidth(self.bounds)),
		.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(viewSize.height, CGRectGetHeight(self.bounds)),
	};

	if ([view respondsToSelector:@selector(viewOriginOffset)])
	{
		CGPoint viewOriginOffset = [view viewOriginOffset];
		origin.x += viewOriginOffset.x;
		origin.y += viewOriginOffset.y;
	}

	return CGRectCeilOrigin((CGRect){
		.origin = origin,
		.size = viewSize,
	});
}

-(CGRect)poppedOffViewFrameForView:(UIView<RUViewStackProtocol>*)view
{
	CGRect visibleViewFrame = [self visibleViewFrameForView:view];
	visibleViewFrame.origin.x -= CGRectGetWidth(self.bounds);
	return CGRectCeilOrigin(visibleViewFrame);
}

-(CGRect)pushedOnViewFrameForView:(UIView<RUViewStackProtocol>*)view
{
	CGRect visibleViewFrame = [self visibleViewFrameForView:view];
	visibleViewFrame.origin.x += CGRectGetWidth(self.bounds);
	return CGRectCeilOrigin(visibleViewFrame);
}

#pragma mark - Update Currently Visible View Frame
-(void)updateCurrentlyVisibleViewFrameAnimated:(BOOL)animated
{
	__weak typeof(self) weak_self = self;

	__weak typeof(self.currentlyVisibleView) currentlyVisibleView_weak = self.currentlyVisibleView;
	kRUConditionalReturn(currentlyVisibleView_weak == nil, YES);

	CGRect newFrame = [self visibleViewFrameForView:currentlyVisibleView_weak];
	kRUConditionalReturn(CGRectEqualToRect(currentlyVisibleView_weak.frame, newFrame), YES);
	
	void (^frameChangeBlock)() = ^{
		kRUConditionalReturn(weak_self == nil, NO);
		kRUConditionalReturn(currentlyVisibleView_weak == nil, NO);

		[currentlyVisibleView_weak setFrame:newFrame];
	};

	if (animated)
	{
		[UIView animateWithDuration:0.25f animations:^{

			frameChangeBlock();

		}];
	}
	else
	{
		frameChangeBlock();
	}
}

@end
