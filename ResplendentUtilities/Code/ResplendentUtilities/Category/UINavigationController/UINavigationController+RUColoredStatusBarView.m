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





NSString* const kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey = @"kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey";
NSString* const kUINavigationController_RUColoredStatusBarView_Key_UINavigationController_RUColoredStatusBarView_Listener = @"kUINavigationController_RUColoredStatusBarView_Key_UINavigationController_RUColoredStatusBarView_Listener";

static void* kUINavigationController_RUColoredStatusBarView__KVOContext = &kUINavigationController_RUColoredStatusBarView__KVOContext;





@class UINavigationController_RUColoredStatusBarView_Listener;
@protocol UINavigationController_RUColoredStatusBarView_Listener_Delegate <NSObject>

-(void)navigationController_RUColoredStatusBarView_Listener:(UINavigationController_RUColoredStatusBarView_Listener*)navigationController_RUColoredStatusBarView_Listener ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification;

-(void)navigationController_RUColoredStatusBarView_Listener_navigationBarFrameDidChange:(UINavigationController_RUColoredStatusBarView_Listener*)navigationController_RUColoredStatusBarView_Listener;

@end





@interface UINavigationController_RUColoredStatusBarView_Listener : NSObject

@property (nonatomic, strong) UINavigationBar* navigationBarToWatchFrameOn;
@property (nonatomic, assign) id<UINavigationController_RUColoredStatusBarView_Listener_Delegate> delegate;

-(void)ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification;

@end





@implementation UINavigationController_RUColoredStatusBarView_Listener

#pragma mark - NSObject
-(instancetype)init
{
	if (self = [super init])
	{
		[self setRegisteredForNotifications_RU_UIApplicationWillChangeStatusBarFrameNotificationOnWithNotificationSelector:@selector(ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:)];
	}

	return self;
}

-(void)dealloc
{
	[self clearRegisteredForNotifications_RU_UIApplicationWillChangeStatusBarFrameNotification];
	[self setRegisteredToCurrentNavigationBarToWatchFrameOn:NO];
}

#pragma mark - navigationBarToWatchFrameOn
-(void)setNavigationBarToWatchFrameOn:(UINavigationBar *)navigationBarToWatchFrameOn
{
	kRUConditionalReturn(self.navigationBarToWatchFrameOn == navigationBarToWatchFrameOn, NO);

	[self setRegisteredToCurrentNavigationBarToWatchFrameOn:NO];

	_navigationBarToWatchFrameOn = navigationBarToWatchFrameOn;

	[self setRegisteredToCurrentNavigationBarToWatchFrameOn:YES];
}

#pragma mark - NSNotificationCenter
-(void)ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
	[self.delegate navigationController_RUColoredStatusBarView_Listener:self ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:notification];
}

#pragma mark - KVO
-(void)setRegisteredToCurrentNavigationBarToWatchFrameOn:(BOOL)registered
{
	kRUConditionalReturn(self.navigationBarToWatchFrameOn == nil, NO);
	
	static NSArray* propertiesToObserve;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		propertiesToObserve = @[
								@"center",
								];
	});
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[self.navigationBarToWatchFrameOn addObserver:self forKeyPath:propertyToObserve options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:&kUINavigationController_RUColoredStatusBarView__KVOContext];
		}
		else
		{
			[self.navigationBarToWatchFrameOn removeObserver:self forKeyPath:propertyToObserve context:&kUINavigationController_RUColoredStatusBarView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kUINavigationController_RUColoredStatusBarView__KVOContext)
	{
		if (object == self.navigationBarToWatchFrameOn)
		{
			[self.delegate navigationController_RUColoredStatusBarView_Listener_navigationBarFrameDidChange:self];
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





@interface UINavigationController (_RUColoredStatusBarView)

@property (nonatomic, strong) UINavigationController_RUColoredStatusBarView_Listener* ru_UINavigationController_RUColoredStatusBarView_Listener;

-(void)ru_updateStatusBarBackgroundView;

@end





@implementation UINavigationController (_RUColoredStatusBarView)

-(void)ru_updateStatusBarBackgroundView
{
	[self.ru_statusBarBackgroundView setFrame:(CGRect){
		.size.width		= CGRectGetWidth(self.view.bounds),
		.size.height	= CGRectGetMinY(self.navigationBar.frame),
	}];
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, _UINavigationController_RUColoredStatusBarView_Listener, UINavigationController_RUColoredStatusBarView_Listener*, &kUINavigationController_RUColoredStatusBarView_Key_UINavigationController_RUColoredStatusBarView_Listener, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

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

			UINavigationController_RUColoredStatusBarView_Listener* navigationController_RUColoredStatusBarView_Listener = [UINavigationController_RUColoredStatusBarView_Listener new];
			[navigationController_RUColoredStatusBarView_Listener setDelegate:(id<UINavigationController_RUColoredStatusBarView_Listener_Delegate>)self];
			[navigationController_RUColoredStatusBarView_Listener setNavigationBarToWatchFrameOn:self.navigationBar];
			[self setRu_UINavigationController_RUColoredStatusBarView_Listener:navigationController_RUColoredStatusBarView_Listener];
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

#pragma mark - UINavigationController_RUColoredStatusBarView_Listener_Delegate
-(void)navigationController_RUColoredStatusBarView_Listener:(UINavigationController_RUColoredStatusBarView_Listener*)navigationController_RUColoredStatusBarView_Listener ru_notificationDidFire_UIApplicationWillChangeStatusBarFrameNotification:(NSNotification*)notification
{
	[self ru_updateStatusBarBackgroundView];
}

-(void)navigationController_RUColoredStatusBarView_Listener_navigationBarFrameDidChange:(UINavigationController_RUColoredStatusBarView_Listener*)navigationController_RUColoredStatusBarView_Listener
{
	[self ru_updateStatusBarBackgroundView];
}

@end
