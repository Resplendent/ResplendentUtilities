//
//  UINavigationController+RUColoredStatusBarView.m
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UINavigationController+RUColoredStatusBarView.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "RUConditionalReturn.h"
#import "NSObject+RUNotifications_UIApplication.h"
#import "RUDeallocHook.h"





NSString* const kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey = @"kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey";
NSString* const kUINavigationController_RUColoredStatusBarView_DeallocHookKey = @"kUINavigationController_RUColoredStatusBarView_DeallocHookKey";

static void* kUINavigationController_RUColoredStatusBarView__KVOContext = &kUINavigationController_RUColoredStatusBarView__KVOContext;





@interface UINavigationController (_RUColoredStatusBarView)

@property (nonatomic, strong) RUDeallocHook* ru_deallocHook;

-(void)ru_updateStatusBarBackgroundView;

-(void)ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification;

@end





@implementation UINavigationController (_RUColoredStatusBarView)

-(void)ru_updateStatusBarBackgroundView
{
	[self.ru_statusBarBackgroundView setFrame:(CGRect){
		.size.width		= CGRectGetWidth(self.view.bounds),
		.size.height	= CGRectGetMinY(self.navigationBar.frame),
	}];
}

-(void)ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
	[self ru_updateStatusBarBackgroundView];
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, _deallocHook, RUDeallocHook*, &kUINavigationController_RUColoredStatusBarView_DeallocHookKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end





@implementation UINavigationController (RUColoredStatusBarView)

#pragma mark - ru_statusBarBackgroundColor
-(UIColor *)ru_statusBarBackgroundColor
{
	return self.ru_statusBarBackgroundView.backgroundColor;
}

-(void)setRu_statusBarBackgroundColor:(UIColor *)ru_statusBarBackgroundColor
{
	kRUConditionalReturn(self.ru_statusBarBackgroundColor == ru_statusBarBackgroundColor, NO);
	
	if (ru_statusBarBackgroundColor)
	{
		if (self.ru_statusBarBackgroundView == nil)
		{
			[self setRu_statusBarBackgroundView:[UIView new]];
			[self ru_updateStatusBarBackgroundView];
			
			[self.ru_statusBarBackgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin)];
			[self.view setAutoresizesSubviews:YES];
			
			[self.view addSubview:self.ru_statusBarBackgroundView];

			[self setRegisteredForNotifications_RU_UIApplicationWillChangeStatusBarFrameNotificationOnWithNotificationSelector:@selector(ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:)];
			static NSString* const kvoKeyPath_navigationBar_frame = @"center";
			[self.navigationBar addObserver:self forKeyPath:kvoKeyPath_navigationBar_frame options:0 context:&kUINavigationController_RUColoredStatusBarView__KVOContext];

			[self setRu_deallocHook:[RUDeallocHook deallocHookWithBlock:^{

				[self clearRegisteredForNotifications_RU_UIApplicationWillChangeStatusBarFrameNotification];
				[self.navigationBar removeObserver:self forKeyPath:kvoKeyPath_navigationBar_frame context:&kUINavigationController_RUColoredStatusBarView__KVOContext];

			}]];
		}
		
		[self.ru_statusBarBackgroundView setBackgroundColor:ru_statusBarBackgroundColor];
	}
	else
	{
		if (self.ru_statusBarBackgroundView)
		{
			[self.ru_statusBarBackgroundView removeFromSuperview];
			[self setRu_statusBarBackgroundView:nil];
		}
	}
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, _statusBarBackgroundView, UIView*, &kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kUINavigationController_RUColoredStatusBarView__KVOContext)
	{
		if (object == self.navigationBar)
		{
			[self ru_updateStatusBarBackgroundView];
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

@end
