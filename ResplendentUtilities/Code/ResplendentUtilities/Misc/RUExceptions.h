//
//  RUExceptions.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUExceptionsUnhandledState(stateVar) \
[NSException exceptionWithName:NSInternalInconsistencyException reason:RUStringWithFormat(@"unhandled state %i",stateVar) userInfo:nil]

@protocol RUExceptions <NSObject>

@end
