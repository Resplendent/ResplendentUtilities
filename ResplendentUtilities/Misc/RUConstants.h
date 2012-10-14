//
//  RUConstants.h
//  Everycam
//
//  Created by Benjamin Maer on 10/13/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RU_OVERRIDE_LOG NSLog(@"<%@:%d> You must override %@ in a subclass", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, NSStringFromSelector(_cmd));
#define RU_MUST_OVERRIDE RU_OVERRIDE_LOG [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a class %@", NSStringFromSelector(_cmd),NSStringFromClass(self.class)];

#define RUDebugLog(...)                                                                 \
NSLog(__VA_ARGS__)
//lcl_log(RKLogComponent, lcl_vDebug, @"" __VA_ARGS__)
