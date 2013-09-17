//
//  RUFourSquareResponseDelegateRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareRequest.h"
#import "RUFourSquareResponse.h"

#import "RUConstants.h"

@implementation RUFourSquareRequest

#pragma mark - Overloaded methods
-(void)didFinishRequestWithJsonResponse:(id)responseJson
{
    [self.delegate fourSquareRequest:self didFinishWithResponse:[[[[self class] responseClass] alloc]initWithRequestObject:self responseObject:responseJson]];
}

-(void)didFailRequestWithError:(NSError *)error
{
    [self.delegate fourSquareRequest:self didFinishWithResponse:[[[[self class] responseClass] alloc]initWithRequestObject:self error:error]];
}

#pragma mark - Getters
+(Class)responseClass
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

@end
