//
//  RUDLog.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RUDebug.h"




#define kRUDLogDeclaration(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)




#if kRUDebugSilenceRUDLog
#define RUDLog(fmt, ...)
#else
#define RUDLog(fmt, ...) kRUDLogDeclaration(fmt, ##__VA_ARGS__)
#endif

#define RU_METHOD_IMPLEMENTATION_NEEDED \
RUDLog(@"@IMPLEMENT Need to implement method")

