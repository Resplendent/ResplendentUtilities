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

@property (nonatomic, readonly) RU_UIApplication_RemoteNotificationsType() ruRemoteTypesToRegisterFor;

-(BOOL)ruOpenDeviceSettingsPage;

@end





@implementation UIApplication (_RU)

-(RU_UIApplication_RemoteNotificationsType())ruRemoteTypesToRegisterFor
{
	return (RU_UIApplication_RemoteNotificationsType(Badge) |
			RU_UIApplication_RemoteNotificationsType(Sound) |
			RU_UIApplication_RemoteNotificationsType(Alert));
}

-(BOOL)ruOpenDeviceSettingsPage
{
	kRUConditionalReturn_ReturnValueFalse(&UIApplicationOpenSettingsURLString == nil, NO);
	
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end





@implementation UIApplication (RU)

-(RU_UIApplication_AppropriateNotificationsType())ruTypesToRegisterFor
{
	return (RU_UIApplication_AppropriateNotificationsType(Badge) |
			RU_UIApplication_AppropriateNotificationsType(Sound) |
			RU_UIApplication_AppropriateNotificationsType(Alert));
}

#pragma mark - RURegisteredForRemoteNotifications
-(BOOL)ruRegisteredForRemoteNotifications
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
	if ([self respondsToSelector:@selector(currentUserNotificationSettings)])
	{
		return (self.currentUserNotificationSettings.types == self.ruTypesToRegisterFor);
	}
	else if ([self respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
	{
		return [self isRegisteredForRemoteNotifications];
	}
	else
	{
		return (self.enabledRemoteNotificationTypes == self.ruRemoteTypesToRegisterFor);
	}
#else
	return (self.enabledRemoteNotificationTypes == self.ruTypesToRegisterFor);
#endif
}

-(void)setRURegisteredForRemoteNotifications:(BOOL)ruRegisteredForRemoteNotifications canSendToSettings:(BOOL)canSendToSettings
{
	if (ruRegisteredForRemoteNotifications)
	{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
		if ([self respondsToSelector:@selector(isRegisteredForRemoteNotifications)] &&
			[self respondsToSelector:@selector(currentUserNotificationSettings)] &&
			[self respondsToSelector:@selector(registerUserNotificationSettings:)])
		{
			if ((canSendToSettings == false) || (self.currentUserNotificationSettings.types == self.ruTypesToRegisterFor) ||
				([self ruOpenDeviceSettingsPage] == false))
			{
				UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:self.ruTypesToRegisterFor categories:nil];
				
				[self registerUserNotificationSettings:settings];
			}
		}
		else
		{
			[self registerForRemoteNotificationTypes:self.ruRemoteTypesToRegisterFor];
		}
#else
		[self registerForRemoteNotificationTypes:self.ruTypesToRegisterFor];
#endif
	}
	else
	{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
		if ([self ruOpenDeviceSettingsPage] == false)
		{
			[self unregisterForRemoteNotifications];
		}
#else
		[self unregisterForRemoteNotifications];
#endif
	}
}

-(void)ruRegisterForPushNotificationsIfAlreadyRegisteredOrNeverRegistered
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
	if ([self respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
	{
		if (self.isRegisteredForRemoteNotifications == self.ruRegisteredForRemoteNotifications)
//		if ((self.isRegisteredForRemoteNotifications == false) ||
//			(self.ruRegisteredForRemoteNotifications == false))
		{
			[self setRURegisteredForRemoteNotifications:YES canSendToSettings:NO];
		}
	}
	else
	{
		if (self.ruRegisteredForRemoteNotifications == false)
		{
			[self setRURegisteredForRemoteNotifications:YES canSendToSettings:NO];
		}
	}
#else
	if (self.ruRegisteredForRemoteNotifications == false)
	{
		[self setRURegisteredForRemoteNotifications:YES canSendToSettings:NO];
	}
#endif
}

@end
