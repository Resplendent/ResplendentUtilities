//
//  RUKeyboardAdjustmentHelper.h
//  LENS
//
//  Created by Benjamin Maer on 10/6/13.
//  Copyright (c) 2013 Novella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUKeyboardAdjustmentHelperProtocols.h"

@interface RUKeyboardAdjustmentHelper : NSObject

@property (nonatomic, readonly) NSNumber* keyboardTop;

@property (nonatomic, assign) id<RUKeyboardAdjustmentHelperDelegate> delegate;

@property (nonatomic, assign) BOOL registeredForKeyboardNotifications;

@end
