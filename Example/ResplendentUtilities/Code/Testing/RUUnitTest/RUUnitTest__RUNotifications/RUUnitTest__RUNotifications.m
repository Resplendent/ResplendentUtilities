//
//  RUUnitTest__RUNotifications.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 7/22/16.
//  Copyright © 2016 Resplendent. All rights reserved.
//

#import "RUUnitTest__RUNotifications.h"

#import "RUNotifications.h"
#import "NSString+RUMacros.h"
#import "RUConditionalReturn.h"





kRUDefineNSStringConstant(kRUUnitTest__RUNotifications__notification_didFire_name)
kRUDefineNSStringConstant(kRUUnitTest__RUNotifications__notification2_didFire_name)





@interface RUUnitTest__RUNotifications ()

#pragma mark - notification
@property (nonatomic, assign) BOOL notification_didFire;
kRUNotifications_Synthesize_NotificationReadonlySetWithSelectorClearProperty(,,notification_setRegistered)
-(void)notification_didFire:(nonnull NSNotification*)notification;

#pragma mark - notification2
@property (nonatomic, assign) BOOL notification2_didFire;
kRUNotifications_Synthesize_NotificationReadonlySetWithSelectorClearProperty(,,notification2_setRegistered)
-(void)notification2_didFire:(nonnull NSNotification*)notification;

@end





@implementation RUUnitTest__RUNotifications

#pragma mark - notification
kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation_AssociatedKey(,,notification_setRegistered, kRUUnitTest__RUNotifications__notification_didFire_name, nil);

-(void)notification_didFire:(nonnull NSNotification*)notification
{
	[self setNotification_didFire:YES];
}

#pragma mark - notification2
kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation_AssociatedKey(,,notification2_setRegistered, kRUUnitTest__RUNotifications__notification2_didFire_name, nil);
-(void)notification2_didFire:(nonnull NSNotification*)notification
{
	[self setNotification2_didFire:YES];
}

#pragma mark - RUUnitTest
-(nullable NSString*)ru_runUnitTest
{
	[self setNotification_didFire:NO];
	[self setnotification_setRegisteredOnWithNotificationSelector:@selector(notification_didFire:)];
	[[NSNotificationCenter defaultCenter]postNotificationName:kRUUnitTest__RUNotifications__notification_didFire_name object:nil];

	kRUConditionalReturn_ReturnValue(self.notification_didFire == NO, NO, @"Notification didn't successfully fire");

	[self setNotification2_didFire:NO];
	[self setnotification2_setRegisteredOnWithNotificationSelector:@selector(notification2_didFire:)];
	[[NSNotificationCenter defaultCenter]postNotificationName:kRUUnitTest__RUNotifications__notification2_didFire_name object:nil];
	
	kRUConditionalReturn_ReturnValue(self.notification2_didFire == NO, NO, @"Notification2 didn't successfully fire");

	return nil;
}

@end
