//
//  RUFourSquareVenueCategoriesRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueCategoriesRequest.h"
#import "RUFourSquareVenueRequestUtil.h"
#import "RUFourSquareVenueCategoriesResponse.h"

@implementation RUFourSquareVenueCategoriesRequest

-(void)fetch
{
    [self fetchWithUrl:[NSURL URLWithString:[RUFourSquareVenueRequestUtil categoriesUrl]]];
}

+(Class)responseClass
{
    return [RUFourSquareVenueCategoriesResponse class];
}

@end
