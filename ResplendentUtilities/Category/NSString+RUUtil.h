//
//  NSString+RUUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 5/9/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUPossiblePluralize(value,singular,suffix) \
[NSString ruProperlyPluralizedStringWithValue:value singularWord:singular possibleSuffix:suffix]

@interface NSString (RUUtil)

+(NSString*)ruProperlyPluralizedStringWithValue:(NSInteger)value singularWord:(NSString*)singularWord possibleSuffix:(NSString*)possibleSuffix;
+(NSString*)ruProperlyPluralizedWordWithValue:(NSInteger)value singularWord:(NSString*)singularWord possibleSuffix:(NSString*)possibleSuffix;

@end
