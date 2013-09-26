//
//  PAYelpRequestController.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* const kRUYelpRequestUtilYelpApiBase = @"http://api.yelp.com/v2/business/yelp-san-francisco/";

@interface RUYelpRequestUtil : NSObject

+(void)setConsumerKey:(NSString*)consumerKey;
+(void)setConsumerSecret:(NSString*)consumerSecret;
+(void)setToken:(NSString*)token;
+(void)setTokenSecret:(NSString*)tokenSecret;

@end
