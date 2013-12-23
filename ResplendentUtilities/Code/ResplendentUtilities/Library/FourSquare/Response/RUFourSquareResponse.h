//
//  RUFourSquareResponse.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUNetworkDictionaryResponse.h"

@interface RUFourSquareResponse : RUNetworkDictionaryResponse

@property (nonatomic, readonly) NSDictionary* meta;
@property (nonatomic, readonly) NSNumber* code;
@property (nonatomic, readonly) BOOL successfulResponse;
@end
