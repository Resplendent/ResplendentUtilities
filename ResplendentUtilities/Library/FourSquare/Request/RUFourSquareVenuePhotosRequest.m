//
//  RUFourSquareVenuePhotosRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenuePhotosRequest.h"
#import "RUFourSquareVenueRequestUtil.h"
#import "RUFourSquareVenuePhotosResponse.h"

@implementation RUFourSquareVenuePhotosRequest

#pragma mark - Public methods
-(void)fetchWithFourSquareVenueId:(NSString*)fourSquareVenueId limit:(NSInteger)limit
{
    if (!fourSquareVenueId.length)
        [NSException raise:NSInvalidArgumentException format:@"Need a non nil fourSquareVenueId"];

    _fourSquareVenueId = fourSquareVenueId;

    [self fetchWithUrl:[NSURL URLWithString:[RUFourSquareVenueRequestUtil photosUrlWithVenueId:fourSquareVenueId limit:limit]]];
}

#pragma mark - Overloaded
+(Class)responseClass
{
    return [RUFourSquareVenuePhotosResponse class];
}

@end
