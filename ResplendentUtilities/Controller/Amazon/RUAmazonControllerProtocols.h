//
//  RUAmazonControllerProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 11/12/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUAmazonController;
@class AmazonServiceResponse;

@protocol RUAmazonControllerDelegate <NSObject>

-(void)amazonController:(RUAmazonController*)amazonController didFinishWithResponse:(AmazonServiceResponse *)response;
-(void)amazonController:(RUAmazonController*)amazonController didFailWithError:(NSError*)error;

@end
