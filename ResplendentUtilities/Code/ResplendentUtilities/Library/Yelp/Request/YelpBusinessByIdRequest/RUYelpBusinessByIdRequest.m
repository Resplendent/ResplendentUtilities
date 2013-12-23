//
//  RUYelpBusinessByIdRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUYelpBusinessByIdRequest.h"
#import "RUYelpBusinessByIdResponse.h"
#import "RUYelpRequestUtil.h"
#import "OAMutableURLRequest.h"
#import "RUConstants.h"

@implementation RUYelpBusinessByIdRequest

-(void)fetchWithId:(NSString*)yelpBusinessId
{
    NSString* searchUrlString = [RUYelpRequestUtil searchBusinessUrlStringForYelpBusinessId:yelpBusinessId];
    if (searchUrlString)
    {
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
    [self.delegate yelpBusinessByIdRequestDelegate:self didFinishWithResponse:[[RUYelpBusinessByIdResponse alloc]initWithRequestObject:self responseObject:responseJson]];;
}

-(void)didFailRequestWithError:(NSError*)error
{
    [self.delegate yelpBusinessByIdRequestDelegate:self didFinishWithResponse:[[RUYelpBusinessByIdResponse alloc]initWithRequestObject:self error:error]];;
}


@end
