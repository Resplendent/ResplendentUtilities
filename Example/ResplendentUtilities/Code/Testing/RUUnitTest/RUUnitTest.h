//
//  RUUnitTest.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 7/22/16.
//  Copyright © 2016 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>





@protocol RUUnitTest <NSObject>

@required
/**
 @description This method should execute the unit test.

 @return If the unit test encounters an issue, it should return a string describing the issue. If no issue is found, it should return nil.
 */
-(nullable NSString*)ru_runUnitTest;

@end
