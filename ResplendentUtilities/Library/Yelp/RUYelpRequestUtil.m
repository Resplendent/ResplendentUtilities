//
//  PAYelpRequestController.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUYelpRequestUtil.h"

static NSString* __consumerKey;
static NSString* __consumerSecret;
static NSString* __token;
static NSString* __tokenSecret;

@implementation RUYelpRequestUtil

#pragma mark - Static Setters
+(void)setConsumerKey:(NSString*)consumerKey {__consumerKey = consumerKey;}
+(void)setConsumerSecret:(NSString*)consumerSecret {__consumerSecret = consumerSecret;}
+(void)setToken:(NSString*)token {__token = token;}
+(void)setTokenSecret:(NSString*)tokenSecret {__tokenSecret = tokenSecret;}

@end
