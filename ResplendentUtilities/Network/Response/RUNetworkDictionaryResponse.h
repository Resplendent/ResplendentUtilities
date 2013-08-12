//
//  RUNetworkDictionaryResponse.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUNetworkResponse.h"

@interface RUNetworkDictionaryResponse : RUNetworkResponse

@property (nonatomic, readonly) NSDictionary* responseDictionary;

@end
