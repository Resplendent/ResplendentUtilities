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
#import "RUDeallocHook.h"





NSString* const kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_aboveContentView = @"kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_aboveContentView";
NSString* const kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ruDeallocHook = @"kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ruDeallocHook";

static void* kUIScrollView_RUAboveContentView__KVOContext = &kUIScrollView_RUAboveContentView__KVOContext;





@interface UIScrollView (_RUAboveContentView)

@property (nonatomic, strong) RUDeallocHook* _ru_UIScrollView_ruDeallocHook;

-(void)_ru_UIScrollView_aboveContentView_updateFrame;
@property (nonatomic, readonly) CGRect _ru_UIScrollView_aboveContentViewFrame;

-(void)_ru_aboveContentView_UIScrollView_setRegistered:(BOOL)registered;

@end





@implementation UIScrollView (_RUAboveContentView)

#pragma mark - Frames
-(CGRect)_ru_UIScrollView_aboveContentViewFrame
{
	return CGRectCeilOrigin((CGRect){
		.origin.y		= MIN(self.contentOffset.y, -CGRectGetHeight(self.frame)),
		.size.width		= CGRectGetWidth(self.frame),
		.size.height	= CGRectGetHeight(self.frame),
	});
}

#pragma mark - Layout
-(void)_ru_UIScrollView_aboveContentView_updateFrame
{
	[self.ru_UIScrollView_aboveContentView setFrame:self._ru_UIScrollView_aboveContentViewFrame];
}

#pragma mark - KVO
-(void)_ru_aboveContentView_UIScrollView_setRegistered:(BOOL)registered
{
	NSArray* propertiesToObserve = @[
									 NSStringFromSelector(@selector(contentOffset)),
									 NSStringFromSelector(@selector(frame)),
									 ];
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[self addObserver:self forKeyPath:propertyToObserve options:(NSKeyValueObservingOptionInitial) context:&kUIScrollView_RUAboveContentView__KVOContext];
		}
		else
		{
			[self removeObserver:self forKeyPath:propertyToObserve context:&kUIScrollView_RUAboveContentView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kUIScrollView_RUAboveContentView__KVOContext)
	{
		if (object == self)
		{
			if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))])
			{
				[self _ru_UIScrollView_aboveContentView_updateFrame];
			}
			else if ([keyPath isEqualToString:NSStringFromSelector(@selector(frame))])
			{
				[self _ru_UIScrollView_aboveContentView_updateFrame];
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

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(_ru, _ru, _UIScrollView_ruDeallocHook, RUDeallocHook*, &kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_ruDeallocHook, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end





@implementation UIScrollView (RUAboveContentView)

#pragma mark - ru_UIScrollView_enableAboveContentView
-(BOOL)ru_UIScrollView_enableAboveContentView
{
	return ((self.ru_UIScrollView_aboveContentView != nil) &&
			(self._ru_UIScrollView_ruDeallocHook != nil));
}

-(void)setRu_UIScrollView_enableAboveContentView:(BOOL)ru_UIScrollView_enableAboveContentView
{
	kRUConditionalReturn(self.ru_UIScrollView_enableAboveContentView == ru_UIScrollView_enableAboveContentView, NO);

	if (ru_UIScrollView_enableAboveContentView)
	{
		kRUConditionalReturn(self.ru_UIScrollView_aboveContentView != nil, YES);
		kRUConditionalReturn(self._ru_UIScrollView_ruDeallocHook != nil, YES);

//		UIView* ru_UIScrollView_aboveContentView = ;
		[self setRu_UIScrollView_aboveContentView:[UIView new]];
		[self addSubview:self.ru_UIScrollView_aboveContentView];

		[self _ru_aboveContentView_UIScrollView_setRegistered:YES];

		__weak typeof(self) weakSelf = self;
		RUDeallocHook* _ru_UIScrollView_ruDeallocHook = [RUDeallocHook deallocHookWithBlock:^{

			[weakSelf _ru_aboveContentView_UIScrollView_setRegistered:NO];

		}];
		[self set_ru_UIScrollView_ruDeallocHook:_ru_UIScrollView_ruDeallocHook];

		[self setNeedsLayout];
	}
	else
	{
		if (self.ru_UIScrollView_aboveContentView)
		{
			[self _ru_aboveContentView_UIScrollView_setRegistered:NO];
			[self.ru_UIScrollView_aboveContentView removeFromSuperview];
			[self setRu_UIScrollView_aboveContentView:nil];
		}
		else
		{
			NSAssert(false, @"unhandled");
		}

		if (self._ru_UIScrollView_ruDeallocHook)
		{
			[self._ru_UIScrollView_ruDeallocHook clearBlock];
			[self set_ru_UIScrollView_ruDeallocHook:nil];
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, _UIScrollView_aboveContentView, UIView*, &kUIScrollView_RUAboveContentView_AssociatedObject_Key_ru_UIScrollView_aboveContentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
