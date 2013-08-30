//
//  RUFourSquareVenueRequestUtil.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueRequestUtil.h"
#import "RUClassOrNilUtil.h"
#import "RUConstants.h"

#define kRUFourSquareVenueRequestBaseUrlPrefix @"https://api.foursquare.com/v2/venues"
#define kRUFourSquareVenueRequestBaseUrlFormatPrefix kRUFourSquareVenueRequestBaseUrlPrefix@"/%@"

NSString* const kRUFourSquareVenueRequestCategoryUrl = kRUFourSquareVenueRequestBaseUrlPrefix@"/categories";

//NSString* const kRUFourSquareVenueRequestBaseUrl = kRUFourSquareVenueRequestBaseUrlPrefix@"/search";
NSString* const kRUFourSquareVenueRequestBaseUrlSearch = kRUFourSquareVenueRequestBaseUrlPrefix@"/search";
NSString* const kRUFourSquareVenueRequestBaseUrlFormat = kRUFourSquareVenueRequestBaseUrlFormatPrefix;
NSString* const kRUFourSquareVenueRequestPhotosBaseUrlFormat = kRUFourSquareVenueRequestBaseUrlFormatPrefix@"/photos";

NSString* const kRUFourSquareVenueRequestApiVersion = @"20130616";

static NSString* urlParamClientId;
static NSString* urlParamClientSecret;

#pragma mark - C methods
NSString* RUFourSquareVenuePhotosRequestURLBaseWithVenueId(NSString* venueId){
    return RUStringWithFormat(kRUFourSquareVenueRequestPhotosBaseUrlFormat,venueId);
}
NSString* RUFourSquareVenueRequestURLBaseWithVenueId(NSString* venueId){
    return RUStringWithFormat(kRUFourSquareVenueRequestBaseUrlFormat,venueId);
}

@implementation RUFourSquareVenueRequestUtil

#pragma mark - URLs
+(NSString*)urlWithBase:(NSString*)baseURL limit:(int)limit
{
    if (!urlParamClientId)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set urlParamClientId"];
    }

    if (!urlParamClientSecret)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must set urlParamClientSecret"];
    }

    NSMutableString* url=[NSMutableString stringWithFormat:@"%@?v=%@",baseURL,kRUFourSquareVenueRequestApiVersion];
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setObject:@"V0NUA5RMLG2KLKKK2VQVIVILI2HQFE2GOYEQWNRSWNOWCQCV" forKey:@"client_id"];
    [parameters setObject:@"CJAQSJQA3RHUCYFNTNJTTZMNZYGFFIRTDXTFVYTDTUP5GU5T" forKey:@"client_secret"];
    
    if (limit)
        [parameters setObject:@(limit) forKey:@"limit"];
    
    for (NSString* key in parameters) {
        id value=[parameters objectForKey:key];
        if ([value isMemberOfClass:[NSNumber class]])
            value=[(NSNumber*)value stringValue];
        [url appendFormat:@"&%@=%@",key,value];
    }
    
    return [NSString stringWithString:url];
}

#pragma mark - Search urls
+(NSString*)searchUrlWithLimit:(int)limit
{
    return [self urlWithBase:kRUFourSquareVenueRequestBaseUrlSearch limit:limit];
}

+(NSString*)searchUrlWithSearchText:(NSString*)searchText latitude:(double)latitude longitude:(double)longitude limit:(NSInteger)limit
{
    NSString* urlString = RUStringWithFormat(@"%@&ll=%f,%f",[RUFourSquareVenueRequestUtil searchUrlWithLimit:limit],latitude,longitude);

    if (searchText.length)
    {
        return [urlString stringByAppendingFormat:@"&query='%@'",[searchText stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }

    return urlString;
}

#pragma mark - Urls
+(NSString*)photosUrlWithVenueId:(NSString*)venueId limit:(int)limit
{
    return [self urlWithBase:RUFourSquareVenuePhotosRequestURLBaseWithVenueId(venueId) limit:limit];
}

+(NSString*)urlForVenueWithId:(NSString*)venueId
{
    return [self urlWithBase:RUFourSquareVenueRequestURLBaseWithVenueId(venueId) limit:0];
}

+(NSString*)categoriesUrl
{
    return [self urlWithBase:kRUFourSquareVenueRequestCategoryUrl limit:0];
}

#pragma mark - Setters
+(void)setClientId:(NSString*)clientId
{
    urlParamClientId = kRUStringOrNil(clientId);
}

+(void)setClientSecret:(NSString*)clientSecret
{
    urlParamClientSecret = kRUStringOrNil(clientSecret);
}

@end
