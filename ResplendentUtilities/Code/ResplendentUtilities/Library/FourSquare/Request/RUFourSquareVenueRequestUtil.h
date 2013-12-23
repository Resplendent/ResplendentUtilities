//
//  RUFourSquareVenueRequestUtil.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSInteger const kRUFourSquareVenueRequestSuccessCode;
extern NSString* const kRUFourSquareVenueRequestCategoryUrl;

@interface RUFourSquareVenueRequestUtil : NSObject

+(NSString*)urlWithBase:(NSString*)baseURL limit:(int)limit;

+(NSString*)searchUrlWithLimit:(int)limit;

+(NSString*)searchUrlWithSearchText:(NSString*)searchText latitude:(double)latitude longitude:(double)longitude limit:(NSInteger)limit;

+(NSString*)photosUrlWithVenueId:(NSString*)venueId limit:(int)limit;
+(NSString*)urlForVenueWithId:(NSString*)venueId;
+(NSString*)categoriesUrl;

+(void)setClientId:(NSString*)clientId;
+(void)setClientSecret:(NSString*)clientSecret;

@end
