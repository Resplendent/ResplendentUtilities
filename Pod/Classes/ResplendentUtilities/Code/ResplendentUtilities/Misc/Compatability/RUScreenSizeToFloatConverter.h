//
//  RUScreenSizeToFloatConverter.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/4/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface RUScreenSizeToFloatConverter : NSObject

@property (nonatomic, readonly) NSDictionary* screenHeightMapping;

-(instancetype)initWithAmountFor480Height:(CGFloat)amountFor480Height
					   amountFor568Height:(CGFloat)amountFor568Heigh;

-(instancetype)initWithAmountFor480Height:(CGFloat)amountFor480Height
					   amountFor568Height:(CGFloat)amountFor568Height
					   amountFor667Height:(CGFloat)amountFor667Height
					   amountFor736Height:(CGFloat)amountFor736Height;

-(CGFloat)appropriateHeightForCurrentScreenHeight;

@end
