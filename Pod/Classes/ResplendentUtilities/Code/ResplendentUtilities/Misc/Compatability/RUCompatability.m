//
//  RUCompatability.m
//
//  Created by Benjamin Maer on 3/21/14.
//  Copyright (c) 2014 Resplendent G.P.. All rights reserved.
//

#import "RUCompatability.h"





@implementation RUCompatability

+(BOOL)screenSizeIs4inch
{
	static NSNumber* screenSizeIs4inch;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		screenSizeIs4inch = @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0f);
	});

    return screenSizeIs4inch.boolValue;
}

+(BOOL)screenSizeIs3Point5inch
{
	static NSNumber* screenSizeIs3Point5inch;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		screenSizeIs3Point5inch = @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480.0f);
	});
	
    return screenSizeIs3Point5inch.boolValue;
}

+(BOOL)isIOS7
{
	static NSNumber* isIOS7;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		isIOS7 = @(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
	});

    return isIOS7.boolValue;
}

+(BOOL)isPreIOS7
{
	static NSNumber* isPreIOS7;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		isPreIOS7 = @(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1);
	});

    return isPreIOS7.boolValue;
}

@end
