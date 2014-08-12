//
//  NSBundle+RUPListGetters.m
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/9/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import "NSBundle+RUPListGetters.h"





@implementation NSBundle (RUPListGetters)

-(NSString*)ruCFBundleShortVersionString
{
	return [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

-(NSString*)ruCFBundleVersionString
{
	return [self objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

-(NSString *)ruFacebookAppID
{
	return [self objectForInfoDictionaryKey:@"FacebookAppID"];
}

@end
