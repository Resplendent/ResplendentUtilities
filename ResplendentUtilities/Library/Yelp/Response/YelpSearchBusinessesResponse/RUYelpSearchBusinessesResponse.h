//
//  RUYelpSearchBusinessResponse.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUNetworkDictionaryResponse.h"

@interface RUYelpSearchBusinessesResponse : RUNetworkDictionaryResponse

@property (nonatomic, readonly) NSDictionary* region;
@property (nonatomic, readonly) NSNumber* total;
@property (nonatomic, readonly) NSArray* businesses;

@end
