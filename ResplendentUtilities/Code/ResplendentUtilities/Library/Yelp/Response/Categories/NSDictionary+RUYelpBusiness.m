//
//  NSDictionary+RUYelpBusiness.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "NSDictionary+RUYelpBusiness.h"

@implementation NSDictionary (RUYelpBusiness)

#pragma mark - Getters
-(NSString *)ruYelpBusinessUid
{
    return [self objectForKey:@"id"];
}

-(NSString *)ruYelpBusinessName
{
    return [self objectForKey:@"name"];
}

-(NSString *)ruYelpBusinessUrl
{
    return [self objectForKey:@"url"];
}

-(NSString *)ruYelpBusinessImageUrl
{
    return [self objectForKey:@"image_url"];
}

-(NSNumber *)ruYelpBusinessReviewCount
{
    return [self objectForKey:@"review_count"];
}

#pragma mark - Only on full business dictionary
-(NSArray *)ruYelpBusinessReviews
{
    return [self objectForKey:@"reviews"];
}

@end
