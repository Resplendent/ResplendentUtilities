//
//  NSString+RUUtil.m
//  Albumatic
//
//  Created by Benjamin Maer on 5/9/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "NSString+RUUtil.h"
#import "RUConstants.h"

@implementation NSString (RUUtil)

+(NSString*)ruProperlyPluralizedStringWithValue:(NSInteger)value singularWord:(NSString*)singularWord possibleSuffix:(NSString*)possibleSuffix
{
    return RUStringWithFormat(@"%i %@",value,[self ruProperlyPluralizedWordWithValue:value singularWord:singularWord possibleSuffix:possibleSuffix]);
}

+(NSString*)ruProperlyPluralizedWordWithValue:(NSInteger)value singularWord:(NSString*)singularWord possibleSuffix:(NSString*)possibleSuffix
{
    if (value == 1)
    {
        return singularWord;
    }
    else
    {
        return [singularWord stringByAppendingString:possibleSuffix];
    }
}

@end
