//
//  RUFourSquareVenueResponse.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueResponse.h"
#import "RUFourSquareVenue.h"

@implementation RUFourSquareVenueResponse

-(id)initWithRequestObject:(RUNetworkRequest *)request responseObject:(id)responseObject
{
    if (self = [super initWithRequestObject:request responseObject:responseObject])
    {
        if (self.successfulResponse)
        {
            _venue = [RUFourSquareVenue fourSquareVenueFromResponse:self.responseDictionary];
        }
    }

    return self;
}

@end
