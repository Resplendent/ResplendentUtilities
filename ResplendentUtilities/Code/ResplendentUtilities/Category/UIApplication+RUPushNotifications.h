//
//  UIApplication+RUPushNotifications.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/8/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>





#define RU_UIApplication_UserNotificationsType(suffix) UIUserNotificationType##suffix
#define RU_UIApplication_RemoteNotificationsType(suffix) UIRemoteNotificationType##suffix

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define RU_UIApplication_AppropriateNotificationsType(suffix) RU_UIApplication_UserNotificationsType(suffix)
#else
#define RU_UIApplication_AppropriateNotificationsType(suffix) RU_UIApplication_RemoteNotificationsType(suffix)
#endif





@interface UIApplication (RUPushNotifications)

@property (nonatomic, readonly) RU_UIApplication_AppropriateNotificationsType() RUTypesToRegisterFor;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@property (nonatomic, readonly) BOOL RURegisteredForRemoteNotifications;
-(void)setRURegisteredForRemoteNotifications:(BOOL)RURegisteredForRemoteNotifications canSendToSettings:(BOOL)canSendToSettings;
#else
@property (nonatomic, assign) BOOL RURegisteredForRemoteNotifications;
#endif

@end
