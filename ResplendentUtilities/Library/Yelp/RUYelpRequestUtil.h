//
//  PAYelpRequestController.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OAMutableURLRequest;

extern NSString* const kRUYelpRequestUtilYelpApiBase;

@interface RUYelpRequestUtil : NSObject

//++++++ Search param methods
/* 
 The follow methods all take a url, and return a url with a search param appended to the url.
 All the params of these methods other than the url are optional if they are NSNumber's, and required if doubles
 */

+(OAMutableURLRequest*)OAuthRequestFromUrl:(NSURL*)url;

//@params searchTerm,latitude,longitude are required
+(NSString*)addSearchByLocationParamsToUrl:(NSString*)url latitude:(double)latitude longitude:(double)longitude accuracy:(NSNumber*)accuracy altitude:(NSNumber*)altitude altitudeAccuracy:(NSNumber*)altitudeAccuracy;

//@params searchTerm,url are required
+(NSString*)addSearchTermParam:(NSString*)searchTerm toUrl:(NSString*)url;

+(NSString*)searchBusinessUrlStringForYelpBusinessId:(NSString*)yelpBusinessId;

//------

+(void)setConsumerKey:(NSString*)consumerKey;
+(void)setConsumerSecret:(NSString*)consumerSecret;
+(void)setToken:(NSString*)token;
+(void)setTokenSecret:(NSString*)tokenSecret;

@end
