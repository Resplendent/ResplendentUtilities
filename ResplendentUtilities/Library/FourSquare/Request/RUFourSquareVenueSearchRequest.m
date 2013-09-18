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
#import "RUFourSquareVenueSearchResponse.h"

@implementation RUFourSquareVenueSearchRequest

-(void)fetchWithCurrentInfo
{
    NSString* urlString = self.urlString;
    if (urlString.length)
    {
        [self fetchWithUrl:[NSURL URLWithString:urlString]];
    }
    else
    {
        RUDLog(@"we need a url string!");
    }
}

-(void)fetchWithSearchText:(NSString*)searchText latitude:(double)latitude longitude:(double)longitude limit:(NSInteger)limit
{
    _latitude = latitude;
    _longitude = longitude;
    _searchText = searchText;
    _limit = limit;

    [self fetchWithCurrentInfo];
}

#pragma mark - Overloaded
+(Class)responseClass
{
    return [RUFourSquareVenueSearchResponse class];
}

#pragma mark - Getters
-(NSString *)urlString
{
    if (!self.latitude || !self.longitude)
    {
        return nil;
    }

    return [RUFourSquareVenueRequestUtil searchUrlWithSearchText:self.searchText latitude:self.latitude longitude:self.longitude limit:self.limit];
}

@end
