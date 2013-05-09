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
    if (value == 1)
    {
        return RUStringWithFormat(@"%i %@",value,singularWord);
    }
    else
    {
        return RUStringWithFormat(@"%i %@%@",value,singularWord,possibleSuffix);
    }
}

@end
