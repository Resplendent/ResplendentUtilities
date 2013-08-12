//
//  RUFourSquareVenue.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUFourSquareVenue : NSObject
{
    NSDictionary* _infoDict;
}

@property (nonatomic, readonly) NSString* uid;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSDictionary* address;
@property (nonatomic, readonly) NSString* fullAddress;

@property (nonatomic, readonly) NSDictionary* contactInfo;
@property (nonatomic, readonly) NSString* contactFormattedPhone;

@property (nonatomic, readonly) NSString* category;
@property (nonatomic, readonly) NSArray* categories;
@property (nonatomic, readonly) NSDictionary* categoryInfo;

@property (nonatomic, readonly) NSNumber* distance;

@property (nonatomic, readonly) NSNumber* longitude;
@property (nonatomic, readonly) NSNumber* latitude;

@property (nonatomic, readonly) NSString* url;

//@property (nonatomic, readonly) NSString* categoryIconUrl;
@property (nonatomic, readonly) NSString* shortAddress;

-(id) initWithFourSquareJSONDict:(NSDictionary*) dict;
//-(NSString*) getCategoryIconURL;
//-(NSString*) generateShortAddress;

-(NSString*)categoryIconUrlWithWidthClosestTo:(NSInteger)width doubleForRetina:(BOOL)doubleForRetina;

//Returns an array of FourSquareVenues generated from the response dictionary
+(instancetype)fourSquareVenueFromResponse:(NSDictionary*) response;
+(NSMutableArray*)fourSquareVenueArrayFromSearchJsonResponse:(NSDictionary*) response;

+(NSString*)categoryIconUrlFromCategoryInfoDict:(NSDictionary*)categoryInfoDict widthClosestTo:(NSInteger)width doubleForRetina:(BOOL)doubleForRetina;

@end
