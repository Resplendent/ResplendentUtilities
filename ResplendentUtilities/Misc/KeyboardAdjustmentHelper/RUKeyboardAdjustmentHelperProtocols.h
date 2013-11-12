//
//  RUKeyboardAdjustmentHelperProtocols.h
//  LENS
//
//  Created by Benjamin Maer on 10/6/13.
//  Copyright (c) 2013 Novella. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUKeyboardAdjustmentHelper;

@protocol RUKeyboardAdjustmentHelperDelegate <NSObject>

-(void)keyboardAdjustmentHelper:(RUKeyboardAdjustmentHelper*)keyboardAdjustmentHelper willShowWithAnimationDuration:(NSTimeInterval)animationDuration;
-(void)keyboardAdjustmentHelper:(RUKeyboardAdjustmentHelper*)keyboardAdjustmentHelper willHideWithAnimationDuration:(NSTimeInterval)animationDuration;

@end
