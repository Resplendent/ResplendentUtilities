//
//  RUNetworkResponse.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUNetworkRequest;

@interface RUNetworkResponse : NSObject

@property (nonatomic, readonly, strong) RUNetworkRequest* request;

@property (nonatomic, readonly, strong) id responseObject;

@property (nonatomic, readonly, strong) NSError* error;

-(id)initWithRequestObject:(RUNetworkRequest*)request responseObject:(id)responseObject;
-(id)initWithRequestObject:(RUNetworkRequest*)request error:(NSError*)error;

@end
