//
//  NSDictionary+RUFourSquareVenueCategory.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "NSDictionary+RUFourSquareVenueCategory.h"

@implementation NSDictionary (RUFourSquareVenueCategory)

-(NSString *)ruFourSquareVenueCategoryName
{
    return [self objectForKey:@"name"];
}

-(NSString *)ruFourSquareVenueCategoryUid
{
    return [self objectForKey:@"id"];
}

-(NSString *)ruFourSquareVenueCategoryPluralName
{
    return [self objectForKey:@"pluralName"];
}

-(NSString *)ruFourSquareVenueCategoryShortName
{
    return [self objectForKey:@"shortName"];
}

-(NSArray *)ruFourSquareVenueCategoryCategories
{
    return [self objectForKey:@"categories"];
}

-(NSDictionary *)ruFourSquareVenueCategoryIcon
{
    return [self objectForKey:@"icon"];
}

@end
