//
//  RURadioButtonViewProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RURadioButtonView;

@protocol RURadioButtonViewSelectionDelegate <NSObject>

-(void)radioButtonView:(RURadioButtonView*)radioButtonView selectedButtonAtIndex:(NSUInteger)buttonIndex;

@end
