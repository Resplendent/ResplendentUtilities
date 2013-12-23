//
//  NSString+RUMutableURLRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 11/15/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "NSString+RUMutableURLRequest.h"

@implementation NSString (RUMutableURLRequest)

-(NSString*)ruEncodedStringForURLParamTerm
{
    return [[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
}

@end
