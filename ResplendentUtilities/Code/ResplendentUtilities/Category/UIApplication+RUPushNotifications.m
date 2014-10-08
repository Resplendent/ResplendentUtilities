//
//  UIApplication+RUPushNotifications.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/8/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIApplication+RUPushNotifications.h"
#import "RUConditionalReturn.h"





@interface UIApplication (_RU)

@property (nonatomic, readonly) RU_UIApplication_RemoteNotificationsType() RURemoteTypesToRegisterFor;

-(BOOL)openDeviceSettingsPage;

@end





@implementation UIApplication (_RU)

-(RU_UIApplication_RemoteNotificationsType())RURemoteTypesToRegisterFor
{
	return (RU_UIApplication_RemoteNotificationsType(Badge) |
			RU_UIApplication_RemoteNotificationsType(Sound) |
			RU_UIApplication_RemoteNotificationsType(Alert));
}

-(BOOL)openDeviceSettingsPage
{
	kRUConditionalReturn_ReturnValueFalse(&UIApplicationOpenSettingsURLString == nil, NO);
	
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end





@implementation UIApplication (RU)

-(RU_UIApplication_AppropriateNotificationsType())RUTypesToRegisterFor
{
	return (RU_UIApplication_AppropriateNotificationsType(Badge) |
			RU_UIApplication_AppropriateNotificationsType(Sound) |
			RU_UIApplication_AppropriateNotificationsType(Alert));
}

#pragma mark - RURegisteredForRemoteNotifications
-(BOOL)RURegisteredForRemoteNotifications
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
	if ([self respondsToSelector:@selector(currentUserNotificationSettings)])
	{
		return (self.currentUserNotificationSettings.types == self.RUTypesToRegisterFor);
	}
	else
	{
		return [self isRegisteredForRemoteNotifications];
	}
#else
	return (self.enabledRemoteNotificationTypes == self.RUTypesToRegisterFor);
#endif
}

-(void)setRURegisteredForRemoteNotifications:(BOOL)RURegisteredForRemoteNotifications canSendToSettings:(BOOL)canSendToSettings
{
	if (RURegisteredForRemoteNotifications)
	{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
		if ([self respondsToSelector:@selector(registerUserNotificationSettings:)])
		{
			if (canSendToSettings && self.isRegisteredForRemoteNotifications)
			{
				[self openDeviceSettingsPage];
			}
			else
			{
				UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:self.RUTypesToRegisterFor categories:nil];
				
				[self registerUserNotificationSettings:settings];
			}
		}
		else
		{
			[self registerForRemoteNotificationTypes:self.RURemoteTypesToRegisterFor];
		}
#else
		[self registerForRemoteNotificationTypes:self.RUTypesToRegisterFor];
#endif
	}
	else
	{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
		if ([self openDeviceSettingsPage] == false)
		{
			[self unregisterForRemoteNotifications];
		}
#else
		[self unregisterForRemoteNotifications];
#endif
	}
}

@end
