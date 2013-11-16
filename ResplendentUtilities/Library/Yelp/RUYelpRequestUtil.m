//
//  PAYelpRequestController.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUYelpRequestUtil.h"
#import "OAMutableURLRequest.h"
#import "RUConstants.h"
#import "NSString+RUMutableURLRequest.h"

NSString* const kRUYelpRequestUtilYelpApiBase = @"http://api.yelp.com/v2/search";
NSString* const kRUYelpRequestUtilYelpBusinessSearchApiBase = @"http://api.yelp.com/v2/business/";

static NSString* __consumerKey;
static NSString* __consumerSecret;
static NSString* __token;
static NSString* __tokenSecret;

@interface RUYelpRequestUtil ()

+(NSString*)urlSearchParamPrefixForUrl:(NSString*)url;

@end

@implementation RUYelpRequestUtil

#pragma mark - Add Auth params
+(OAMutableURLRequest*)OAuthRequestFromUrl:(NSURL*)url
{
    if (!__consumerKey)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set Yelp consumerKey before making requests"];
    }
    if (!__consumerSecret)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set Yelp consumerSecret before making requests"];
    }
    if (!__token)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set Yelp token before making requests"];
    }
    if (!__tokenSecret)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set Yelp tokenSecret before making requests"];
    }

    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:__consumerKey secret:__consumerSecret];
    OAToken *token = [[OAToken alloc] initWithKey:__token secret:__tokenSecret];

    OAHMAC_SHA1SignatureProvider* provider = [OAHMAC_SHA1SignatureProvider new];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:realm
                                                          signatureProvider:provider];
    [request prepare];

    return request;
}

#pragma mark - Add Search params
+(NSString*)urlSearchParamPrefixForUrl:(NSString*)url
{
    return ([url rangeOfString:@"?"].location == NSNotFound ? @"?" : @"&");;
}

+(NSString*)addSearchByLocationParamsToUrl:(NSString*)url latitude:(double)latitude longitude:(double)longitude accuracy:(NSNumber*)accuracy altitude:(NSNumber*)altitude altitudeAccuracy:(NSNumber*)altitudeAccuracy
{
    NSString* prefix = [self urlSearchParamPrefixForUrl:url];
    url = [url stringByAppendingFormat:@"%@ll=%f,%f",prefix,latitude,longitude];

    if (accuracy)
    {
        url = [url stringByAppendingFormat:@",%f",accuracy.doubleValue];

        if (altitude)
        {
            url = [url stringByAppendingFormat:@",%f",altitude.doubleValue];
            if (altitudeAccuracy)
            {
                url = [url stringByAppendingFormat:@",%f",altitudeAccuracy.doubleValue];
            }
        }
    }

    return url;
}

+(NSString*)addSearchTermParam:(NSString*)searchTerm toUrl:(NSString*)url
{
    NSString* encodedStringForURLParamTerm = [searchTerm ruEncodedStringForURLParamTerm];
    if (encodedStringForURLParamTerm.length)
    {
        return RUStringWithFormat(@"%@%@term=%@",url,[self urlSearchParamPrefixForUrl:url],encodedStringForURLParamTerm);
    }
    else
    {
        RUDLog(@"need non-nil search term to add to url %@",url);
        return nil;
    }
}

#pragma mark - Search Business by Uid
+(NSString*)searchBusinessUrlStringForYelpBusinessId:(NSString*)yelpBusinessId
{
    if (yelpBusinessId.length)
    {
        return RUStringWithFormat(@"%@%@",kRUYelpRequestUtilYelpBusinessSearchApiBase,yelpBusinessId);
    }
    else
    {
        RUDLog(@"need non-nil yelpBusinessId");
        return nil;
    }
}

#pragma mark - Static Setters
+(void)setConsumerKey:(NSString*)consumerKey {__consumerKey = consumerKey;}
+(void)setConsumerSecret:(NSString*)consumerSecret {__consumerSecret = consumerSecret;}
+(void)setToken:(NSString*)token {__token = token;}
+(void)setTokenSecret:(NSString*)tokenSecret {__tokenSecret = tokenSecret;}

@end
