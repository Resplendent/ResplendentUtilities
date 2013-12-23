//
//  RUFourSquareResponseDelegateRequestProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUFourSquareRequest;
@class RUFourSquareResponse;

@protocol RUFourSquareRequestDelegate <NSObject>

-(void)fourSquareRequest:(RUFourSquareRequest*)request didFinishWithResponse:(RUFourSquareResponse*)response;

@end
