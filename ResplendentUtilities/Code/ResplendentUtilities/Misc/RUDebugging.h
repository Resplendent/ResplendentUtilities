//
//  RUDebugging.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/2/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUConstants.h"

#define RUDebugTimerBeginWithTimerVarName(timerVarName) \
NSDate* timerVarName = [NSDate date];

#define RUDebugTimerLogWithTimerVarName(timerVarName) \
RUDLog(@"total time: %f",[[NSDate date]timeIntervalSinceDate:timerVarName]);

#define RUDebugTimerBegin \
RUDebugTimerBeginWithTimerVarName(__durationDebugger__)

#define RUDebugTimerLog \
RUDebugTimerLogWithTimerVarName(__durationDebugger__)

