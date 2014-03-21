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
    if (!screenSizeIs4inch)
    {
        screenSizeIs4inch = @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480.0);
    }
    return screenSizeIs4inch.boolValue;
}

+(BOOL)isIOS7
{
	static NSNumber* isIOS7;
    if (!isIOS7)
    {
        isIOS7 = @(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
    }
    return isIOS7.boolValue;
}

@end
