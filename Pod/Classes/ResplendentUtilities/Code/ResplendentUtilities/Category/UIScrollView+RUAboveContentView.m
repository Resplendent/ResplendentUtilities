//
//  UIScrollView+RUAboveContentView.m
//  Shimmur
//
//  Created by Benjamin Maer on 4/4/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "UIScrollView+RUAboveContentView.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "UIView+RUUtility.h"
#import "RUConditionalReturn.h"





NSString* const kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView = @"kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView";

static void* kUIScrollView_RUAboveContentView__KVOContext = &kUIScrollView_RUAboveContentView__KVOContext;





// ++ _RU_UIScrollView_AboveContentView_UpdatingView
@interface _RU_UIScrollView_AboveContentView_UpdatingView : UIView

@property (nonatomic, readonly) CGRect aboveContentViewFrame;

-(void)setRegisteredToScrollView:(BOOL)registered;
-(void)setRegisteredToScrollView:(UIScrollView*)scrollView registered:(BOOL)registered;

@end





@implementation _RU_UIScrollView_AboveContentView_UpdatingView

#pragma mark - UIView
-(void)layoutSubviews
{
	[super layoutSubviews];

	if (self.superview)
	{
		[self setFrame:self.aboveContentViewFrame];
	}
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];

	if (self.superview)
	{
		UIScrollView* scrollView = kRUClassOrNil(self.superview, UIScrollView);
		[self setRegisteredToScrollView:scrollView registered:NO];
	}

	if (newSuperview)
	{
		UIScrollView* scrollView = kRUClassOrNil(newSuperview, UIScrollView);
		[self setRegisteredToScrollView:scrollView registered:YES];
	}
}

#pragma mark - KVO
-(void)setRegisteredToScrollView:(BOOL)registered
{
	UIScrollView* scrollView = kRUClassOrNil([self superview], UIScrollView);
	kRUConditionalReturn(scrollView == nil, NO);

	[self setRegisteredToScrollView:scrollView registered:registered];
}

-(void)setRegisteredToScrollView:(UIScrollView*)scrollView registered:(BOOL)registered
{
	kRUConditionalReturn(scrollView == nil, NO);

	NSArray* propertiesToObserve = @[
									 NSStringFromSelector(@selector(contentOffset)),
									 NSStringFromSelector(@selector(frame)),
									 ];

	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[scrollView addObserver:self forKeyPath:propertyToObserve options:(0) context:&kUIScrollView_RUAboveContentView__KVOContext];
		}
		else
		{
			[scrollView removeObserver:self forKeyPath:propertyToObserve context:&kUIScrollView_RUAboveContentView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kUIScrollView_RUAboveContentView__KVOContext)
	{
		if (object == self.superview &&
			(kRUClassOrNil(self.superview, UIScrollView) != nil))
		{
			if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))])
			{
				[self setNeedsLayout];
			}
			else if ([keyPath isEqualToString:NSStringFromSelector(@selector(frame))])
			{
				[self setNeedsLayout];
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - Frames
-(CGRect)aboveContentViewFrame
{
	UIScrollView* scrollView = kRUClassOrNil([self superview], UIScrollView);
	kRUConditionalReturn_ReturnValue(scrollView == nil, YES, CGRectZero);

	return CGRectCeilOrigin((CGRect){
		.origin.y		= MIN(scrollView.contentOffset.y, -CGRectGetHeight(scrollView.frame)),
		.size.width		= CGRectGetWidth(scrollView.frame),
		.size.height	= CGRectGetHeight(scrollView.frame),
	});
}

@end
// -- _RU_UIScrollView_AboveContentView_UpdatingView





@interface UIScrollView (_RUAboveContentView)

@property (nonatomic, strong) _RU_UIScrollView_AboveContentView_UpdatingView* _ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView;

@end





@implementation UIScrollView (_RUAboveContentView)

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(_ru, _ru, _UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView, _RU_UIScrollView_AboveContentView_UpdatingView*, &kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end





@implementation UIScrollView (RUAboveContentView)

#pragma mark - ru_UIScrollView_enableAboveContentView
-(BOOL)ru_UIScrollView_enableAboveContentView
{
	return (self.ru_UIScrollView_aboveContentView != nil);
}

-(void)setRu_UIScrollView_enableAboveContentView:(BOOL)ru_UIScrollView_enableAboveContentView
{
	kRUConditionalReturn(self.ru_UIScrollView_enableAboveContentView == ru_UIScrollView_enableAboveContentView, NO);

	if (ru_UIScrollView_enableAboveContentView)
	{
		kRUConditionalReturn(self._ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView != nil, YES);

		_RU_UIScrollView_AboveContentView_UpdatingView* aboveContentView_Updater = [_RU_UIScrollView_AboveContentView_UpdatingView new];
		[self addSubview:aboveContentView_Updater];
		[self set_ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView:aboveContentView_Updater];
	}
	else
	{
		kRUConditionalReturn(self._ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView == nil, YES);

		[self._ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView removeFromSuperview];
		[self set_ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView:nil];
	}
}

#pragma mark - ru_UIScrollView_aboveContentView
-(UIView *)ru_UIScrollView_aboveContentView
{
	return self._ru_UIScrollView_RU_UIScrollView_AboveContentView_UpdatingView;
}

@end
