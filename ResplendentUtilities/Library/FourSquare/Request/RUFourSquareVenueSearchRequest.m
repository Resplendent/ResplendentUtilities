//
//  RUFourSquareVenueSearchRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueSearchRequest.h"
#import "RUFourSquareVenueRequestUtil.h"
#import "RUConstants.h"

NSInteger const kRUFourSquareVenueSearchRequestFetchLimit = 20;


@implementation RUFourSquareVenueSearchRequest

-(void)fetchWithLatitude:(double)latitude longitude:(double)longitude
{
    _latitude = latitude;
    _longitude = longitude;

    [self fetchWithUrl:[NSURL URLWithString:[RUFourSquareVenueRequestUtil searchUrlWithLatitude:latitude longitude:longitude limit:kRUFourSquareVenueSearchRequestFetchLimit]]];
}

@end
