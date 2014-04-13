//
//  UIColor+HexString.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/31/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "UIColor+RUHexString.h"





@implementation UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)string
{
    unsigned int value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    if ([[string substringToIndex:2] isEqualToString:@"0x"] && string.length == 8)
        [scanner setScanLocation:2];
    [scanner scanHexInt:&value];

    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:1.0];
}

@end
