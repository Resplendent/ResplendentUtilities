//
//  RUYelpBusinessByIdRequestProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUYelpBusinessByIdRequest;
@class RUYelpBusinessByIdResponse;

@protocol RUYelpBusinessByIdRequestDelegate <NSObject>

-(void)yelpBusinessByIdRequestDelegate:(RUYelpBusinessByIdRequest*)request didFinishWithResponse:(RUYelpBusinessByIdResponse*)response;

@end
