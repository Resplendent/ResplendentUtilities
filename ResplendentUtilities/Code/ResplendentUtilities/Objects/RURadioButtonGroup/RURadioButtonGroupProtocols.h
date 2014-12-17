//
//  RURadioButtonGroupProtocols.h
//  Shimmur
//
//  Created by Benjamin Maer on 12/16/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RURadioButtonGroup;





@protocol RURadioButtonGroupButtonSelectionDelegate <NSObject>

-(void)radioButtonGroup:(RURadioButtonGroup*)radioButtonGroup pressedButtonAtIndex:(NSInteger)selectedButtonIndex;

@end
