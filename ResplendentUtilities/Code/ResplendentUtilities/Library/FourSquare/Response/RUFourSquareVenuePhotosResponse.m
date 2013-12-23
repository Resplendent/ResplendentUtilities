//
//  RUFourSquareVenuePhotosResponse.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenuePhotosResponse.h"
#import "RUFourSquareVenuePhoto.h"
#import "RUFourSquareVenuePhotosRequest.h"

@implementation RUFourSquareVenuePhotosResponse

-(id)initWithRequestObject:(RUNetworkRequest *)request responseObject:(id)responseObject
{
    if (self = [super initWithRequestObject:request responseObject:responseObject])
    {
        if (self.successfulResponse)
        {
            _venuePhotos = [NSArray arrayWithArray:[RUFourSquareVenuePhoto fourSquareVenuePhotosForResponseDict:[self.responseDictionary objectForKey:@"response"]]];
        }
    }
    
    return self;
}

@end
