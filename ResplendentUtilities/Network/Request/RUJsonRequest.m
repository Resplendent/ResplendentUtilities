//
//  RUJsonRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/14/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUJsonRequest.h"
#import "JSONKit.h"
#import "RUConstants.h"

@implementation RUJsonRequest

-(void)didFinishRequestWithResponseString:(NSString *)responseString
{
    [self didFinishRequestWithJsonResponse:[responseString objectFromJSONString]];
}

-(void)didFinishRequestWithJsonResponse:(id)responseJson
{
    RUDLog(@"%@",responseJson);
}

@end
