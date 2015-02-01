//
//  UIApplication+RUPushNotifications.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/8/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIApplication+RUPushNotifications.h"
#import "RUConditionalReturn.h"





@interface UIApplication (_RUPushNotifications)

@property (nonatomic, readonly) RU_UIApplication_RemoteNotificationsType() ruRemoteTypesToRegisterFor;

-(BOOL)ruOpenDeviceSettingsPage;

@end





@implementation UIApplication (_RUPushNotifications)

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





@implementation UIApplication (RUPushNotifications)

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
		if ((canSendToSettings == false) || [self ruOpenDeviceSettingsPage] == false)
		{
			[self unregisterForRemoteNotifications];
		}
#else
		[self unregisterForRemoteNotifications];
#endif
	}
}

-(BOOL)ru_alreadyRegisteredOrNeverRegisteredForPushNotifications
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
	if ([self respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
	{
		return (self.isRegisteredForRemoteNotifications == self.ruRegisteredForRemoteNotifications);
	}
	else
	{
		return (self.ruRegisteredForRemoteNotifications == false);
	}
#else
	return (self.ruRegisteredForRemoteNotifications == false);
#endif
}

-(void)ruRegisterForPushNotificationsIfAlreadyRegisteredOrNeverRegistered
{
	if (self.ru_alreadyRegisteredOrNeverRegisteredForPushNotifications)
	{
		[self setRURegisteredForRemoteNotifications:YES canSendToSettings:NO];
	}
}

@end
