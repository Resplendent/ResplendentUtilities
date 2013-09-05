//
//  RUFourSquareVenue.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenue.h"
#import "RUClassOrNilUtil.h"
#import "RUConstants.h"

@interface RUFourSquareVenue ()

+(NSString*)cityStateCountryAddressChunkWithAddressDict:(NSDictionary*)addressDict;

@end

@implementation RUFourSquareVenue

-(id) initWithFourSquareJSONDict:(NSDictionary*) dict
{
    _infoDict = [NSDictionary dictionaryWithDictionary:dict];
    
    return (self = [self init]);
}

-(id)init
{
    if (self = [super init])
    {
        if (!self.category)
        {
#if kPAFourSquareVenueWhineOnNilCategory
            RUDLog(@"four square venue with dict %@ has no category. this is a test for category effectiveness",dict);
#endif
            return nil;
        }
    }
    
    return self;
}

-(NSString *)uid
{
    return [_infoDict objectForKey:@"id"];
}

-(NSNumber *)longitude
{
    return [self.addressDict objectForKey:@"lng"];
}

-(NSNumber *)latitude
{
    return [self.addressDict objectForKey:@"lat"];
}

-(NSString *)category
{
    return self.categoryInfo.RUFourSquareVenueCategoryInfoPluralName;
}

-(NSDictionary *)categoryInfo
{
    return (self.categories.count ? [self.categories objectAtIndex:0] : nil);
}

-(NSArray *)categories
{
    return [_infoDict objectForKey:@"categories"];
}

-(NSNumber *)distance
{
    return [self.addressDict objectForKey:@"distance"];
}

-(NSDictionary *)contactInfo
{
    return [_infoDict objectForKey:@"contact"];
}

-(NSString *)contactFormattedPhone
{
    return [self.contactInfo objectForKey:@"formattedPhone"];
}

-(NSDictionary *)addressDict
{
    return [_infoDict objectForKey:@"location"];
}

-(NSString *)name
{
    return [_infoDict objectForKey:@"name"];
}

+(NSString*)categoryIconUrlFromCategoryInfoDict:(NSDictionary*)categoryInfoDict widthClosestTo:(NSInteger)width doubleForRetina:(BOOL)doubleForRetina
{
    NSDictionary* urlDict = [categoryInfoDict objectForKey:@"icon"];
    
    NSNumber* targetedDimension = @(width);
    
    NSArray* imageSizeArray = [urlDict objectForKey:@"sizes"];
    if (imageSizeArray)
    {
        targetedDimension = ([imageSizeArray containsObject:targetedDimension] ? targetedDimension : [imageSizeArray lastObject]);
    }
    
    if (targetedDimension)
    {
        if (doubleForRetina && [[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            targetedDimension = @(targetedDimension.integerValue * [UIScreen mainScreen].scale);
        }
    }
    
    NSString* prefix = [urlDict objectForKey:@"prefix"];
    NSString* suffix = [urlDict objectForKey:@"suffix"];
    
    if (suffix.length)
    {
        //If suffix exists, then we're using bg supported version
        prefix = [prefix stringByAppendingString:@"bg_"];
    }
    else
    {
        suffix = [urlDict objectForKey:@"name"];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",prefix,targetedDimension,suffix];
}

-(NSString*)categoryIconUrlWithWidthClosestTo:(NSInteger)width doubleForRetina:(BOOL)doubleForRetina
{
    return [RUFourSquareVenue categoryIconUrlFromCategoryInfoDict:self.categoryInfo widthClosestTo:width doubleForRetina:doubleForRetina];
}

-(NSString*)fullAddress
{
    return [[self class]fullAddressWithAddressDict:self.addressDict];
}

-(NSString*)shortAddress
{
    return [self.addressDict objectForKey:@"address"];
}

-(NSString *)url
{
    return [_infoDict objectForKey:@"url"];
}

#pragma mark - static methods
+(instancetype)fourSquareVenueFromResponse:(NSDictionary *)response
{
    NSDictionary* JSONvenue = [[response objectForKey:@"response"] objectForKey:@"venue"];
    return [[self alloc] initWithFourSquareJSONDict:JSONvenue];
}

+(NSMutableArray*)fourSquareVenueArrayFromSearchJsonResponse:(NSDictionary*)jsonResponse
{
    NSArray* venuesJson = [[jsonResponse objectForKey:@"response"] objectForKey:@"venues"];
    
    NSMutableArray* venues = [NSMutableArray arrayWithCapacity:venuesJson.count];
    
    for (NSDictionary* JSONvenue in venuesJson)
    {
        RUFourSquareVenue* fsv = [[self alloc] initWithFourSquareJSONDict:JSONvenue];
        if (fsv)
        {
            [venues addObject:fsv];
        }
    }
    
    return venues;
}

+(NSString*)cityStateCountryAddressChunkWithAddressDict:(NSDictionary*)addressDict
{
    NSString* city = kRUStringOrNil(addressDict.RUFourSquareVenueLocationInfoCity);
    NSString* state = kRUStringOrNil(addressDict.RUFourSquareVenueLocationInfoState);
    NSString* country = kRUStringOrNil(addressDict.RUFourSquareVenueLocationInfoCountry);
    
    if (!city.length && !state.length && !country.length)
    {
        return nil;
    }
    
    if (city.length && state.length)
    {
        return RUStringWithFormat(@"%@ %@",city,state);
    }
    else
    {
        if (city.length)
        {
            return city;
        }
        else if (state.length)
        {
            return state;
        }
        else
        {
            return country;
        }
    }
}

+(NSString*)fullAddressWithAddressDict:(NSDictionary*)addressDict
{
    NSString* initialCityStateCountryAddressChunk = [self cityStateCountryAddressChunkWithAddressDict:addressDict];
    if (!initialCityStateCountryAddressChunk.length)
    {
        return nil;
    }

    NSMutableString* fullAddress = [NSMutableString stringWithString:initialCityStateCountryAddressChunk];

    NSString* address = kRUStringOrNil(addressDict.RUFourSquareVenueLocationInfoAddress);
    if (address.length)
    {
        [fullAddress insertString:RUStringWithFormat(@"%@ ",address) atIndex:0];
    }

    id postalCode = addressDict.RUFourSquareVenueLocationInfoPostalCode;
    if (postalCode)
    {
        [fullAddress appendFormat:@" %@",postalCode];
    }

    return [NSString stringWithString:fullAddress];
}

@end

@implementation NSDictionary (RUFourSquareVenueCategoryInfo)

-(NSString *)RUFourSquareVenueCategoryInfoPluralName
{
    return [self objectForKey:@"pluralName"];
}

@end

@implementation NSDictionary (RUFourSquareVenueLocationInfo)

-(NSString *)RUFourSquareVenueLocationInfoCity
{
    return [self objectForKey:@"city"];
}

-(NSString *)RUFourSquareVenueLocationInfoState
{
    return [self objectForKey:@"state"];
}

-(NSString *)RUFourSquareVenueLocationInfoCountry
{
    return [self objectForKey:@"country"];
}

-(NSString *)RUFourSquareVenueLocationInfoAddress
{
    return [self objectForKey:@"address"];
}

-(id)RUFourSquareVenueLocationInfoPostalCode
{
    return [self objectForKey:@"postalCode"];
}

@end
