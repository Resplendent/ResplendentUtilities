//
//  RUYelpSearchBusinessesRequestProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUYelpSearchBusinessesRequest;
@class RUYelpSearchBusinessesResponse;

@protocol RUYelpSearchBusinessesRequestDelegate <NSObject>

-(void)yelpSearchBusinessesRequest:(RUYelpSearchBusinessesRequest*)request didFinishWithResponse:(RUYelpSearchBusinessesResponse*)response;

@end
