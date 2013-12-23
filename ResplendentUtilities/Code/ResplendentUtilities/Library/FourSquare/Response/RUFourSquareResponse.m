//
//  RUFourSquareResponse.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareResponse.h"

NSInteger const kRUFourSquareResponseSuccessCode = 200;

@implementation RUFourSquareResponse

-(NSDictionary *)meta
{
    return [self.responseDictionary objectForKey:@"meta"];
}

-(NSNumber *)code
{
    return [self.meta objectForKey:@"code"];
}

-(BOOL)successfulResponse
{
    return (self.code.integerValue == kRUFourSquareResponseSuccessCode);
}

@end
