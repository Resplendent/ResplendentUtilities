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

#define RUDebugLog(...) NSLog(__VA_ARGS__)

#define METHOD_IMPLEMENTATION_NEEDED NSLog(@"@IMPLEMENT Need to implement method %@ in class %@",NSStringFromSelector(_cmd),NSStringFromClass([self class]))
//lcl_log(RKLogComponent, lcl_vDebug, @"" __VA_ARGS__)
