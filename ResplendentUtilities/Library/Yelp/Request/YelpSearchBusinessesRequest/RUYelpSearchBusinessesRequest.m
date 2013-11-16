//
//  RUYelpSearchBusinessesRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUYelpSearchBusinessesRequest.h"
#import "RUYelpRequestUtil.h"
#import "RUYelpSearchBusinessesResponse.h"
#import "OAMutableURLRequest.h"
#import "RUConstants.h"

@implementation RUYelpSearchBusinessesRequest

#pragma mark - Fetch
-(void)fetchWithLatitude:(double)latitude longitude:(double)longitude searchTerm:(NSString *)searchTerm
{
    NSString* searchUrlString = [RUYelpRequestUtil addSearchByLocationParamsToUrl:kRUYelpRequestUtilYelpApiBase latitude:latitude longitude:longitude accuracy:nil altitude:nil altitudeAccuracy:nil];
    if (searchUrlString)
    {
        if (searchTerm.length)
        {
            searchUrlString = [RUYelpRequestUtil addSearchTermParam:searchTerm toUrl:searchUrlString];
        }

        NSURL* searchUrl = [NSURL URLWithString:searchUrlString];
        if (searchUrl)
        {
            OAMutableURLRequest* urlRequest = [RUYelpRequestUtil OAuthRequestFromUrl:searchUrl];
            if (urlRequest)
            {
                [self fetchWithUrlRequest:urlRequest];
            }
            else
            {
                RUDLog(@"couldn't produce urlRequest from url %@",searchUrl);
            }
        }
        else
        {
            RUDLog(@"couldn't produce search url with search string %@",searchUrlString);
        }
    }
    else
    {
        RUDLog(@"Couldn't produce search string");
    }
}

#pragma mark - Overloaded Completions
-(void)didFinishRequestWithJsonResponse:(id)responseJson
{
    [self.delegate yelpSearchBusinessesRequest:self didFinishWithResponse:[[RUYelpSearchBusinessesResponse alloc]initWithRequestObject:self responseObject:responseJson]];
}

-(void)didFailRequestWithError:(NSError*)error
{
    [self.delegate yelpSearchBusinessesRequest:self didFinishWithResponse:[[RUYelpSearchBusinessesResponse alloc]initWithRequestObject:self error:error]];
}

@end
