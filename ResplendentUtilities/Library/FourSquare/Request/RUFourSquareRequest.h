//
//  RUFourSquareResponseDelegateRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUJsonRequest.h"
#import "RUFourSquareRequestProtocols.h"

@interface RUFourSquareRequest : RUJsonRequest

@property (nonatomic, assign) id<RUFourSquareRequestDelegate>delegate;

//Must be overloaded by sublcass
+(Class)responseClass;

@end
