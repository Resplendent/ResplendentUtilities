//
//  RUNotifications.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/20/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUSynthesizeAssociatedObjects.h"

#define kRUNotifications_Synthesize_NotificationReadonlySetWithSelectorClearProperty(v,V,arName) \
@property (nonatomic, readonly) BOOL v##arName; \
-(void)set##V##arName##OnWithNotificationSelector:(SEL)notificationSelector; \
-(void)clear##V##arName;

#define kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation(v,V,arName,constVoidKey,notificationName,notificationObject) \
-(void)set##V##arName##OnWithNotificationSelector:(SEL)notificationSelector \
{ \
if ([self v##arName] == YES) \
return; \
[self set##V##arName:YES]; \
[[NSNotificationCenter defaultCenter]addObserver:self selector:notificationSelector name:notificationName object:notificationObject]; \
} \
-(void)clear##V##arName \
{ \
if ([self v##arName] == NO) \
return;\
[self set##V##arName:NO]; \
[[NSNotificationCenter defaultCenter]removeObserver:self name:notificationName object:notificationObject]; \
\
} \
RU_Synthesize_AssociatedObject_GetterSetterNumberFromPrimative_Implementation(v, V, arName, BOOL, boolValue, constVoidKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

#define kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation_AssociatedKey(v,V,arName,notificationName,notificationObject) \
NSString* const __kNotificationAssociatedKey##notificationName; \
kRUNotifications_Synthesize_NotificationGetterSetterNumberFromPrimative_Implementation(v,V,arName,&__kNotificationAssociatedKey##notificationName,notificationName,notificationObject)
