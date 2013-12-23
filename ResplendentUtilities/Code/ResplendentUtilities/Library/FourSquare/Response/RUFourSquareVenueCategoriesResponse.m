//
//  RUFourSquareVenueCategoriesResponse.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueCategoriesResponse.h"

#import "RUConstants.h"

@implementation RUFourSquareVenueCategoriesResponse

-(id)initWithRequestObject:(RUNetworkRequest *)request responseObject:(id)responseObject
{
    if (self = [super initWithRequestObject:request responseObject:responseObject])
    {
//        RUDLog(@"self.responseDictionary %@",self.responseDictionary);

//        if (self.successfulResponse)
//        {
//            
//            _venue = [RUFourSquareVenue fourSquareVenueFromResponse:self.responseDictionary];
//        }
    }
    
    return self;
}

-(NSArray *)categories
{
    return [[self.responseDictionary objectForKey:@"response"] objectForKey:@"categories"];
}

@end
