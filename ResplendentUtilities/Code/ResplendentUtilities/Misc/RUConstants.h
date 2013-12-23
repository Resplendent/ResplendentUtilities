//
//  RUConstants.h
//  Everycam
//
//  Created by Benjamin Maer on 10/13/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RU_OVERRIDE_LOG NSLog(@"<%@:%d> You must override %@ in a subclass", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, NSStringFromSelector(_cmd));
#define RU_MUST_OVERRIDE [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%s must override %@ in a class %@",__PRETTY_FUNCTION__,NSStringFromSelector(_cmd),NSStringFromClass(self.class)] userInfo:nil];

#define RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION \
@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:RUStringWithFormat(@"%@ must overload",NSStringFromClass([self class])) userInfo:nil];

#define RUStringWithFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#define RUiOSSystemVersionIsAtLeast(version) ([UIDevice currentDevice].systemVersion.floatValue >= version)

#define RUSizeAdjustedToDeviceScreenSize(sourceSize) ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? CGSizeMake(sourceSize.width * [[UIScreen mainScreen] scale],sourceSize.height * [[UIScreen mainScreen] scale]) : sourceSize)

//Enums
typedef enum{
    RUScrollDirectionNone = 0,
    RUScrollDirectionDown = 100,
    RUScrollDirectionUp
}RUScrollDirection;
