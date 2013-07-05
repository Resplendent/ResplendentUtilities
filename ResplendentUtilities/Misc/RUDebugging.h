//
//  RUDebugging.h
//  Albumatic
//
//  Created by Benjamin Maer on 7/2/13.
//  Copyright (c) 2013 Albumatic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUConstants.h"

#define RUDebugTimerBegin \
NSDate* __durationDebugger__ = [NSDate date];

#define RUDebugTimerLog \
RUDLog(@"total time: %f",[[NSDate date]timeIntervalSinceDate:__durationDebugger__]);

