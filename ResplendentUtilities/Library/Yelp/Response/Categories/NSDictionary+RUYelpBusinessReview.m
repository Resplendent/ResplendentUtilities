//
//  NSDictionary+RUYelpBusinessReview.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "NSDictionary+RUYelpBusinessReview.h"

@implementation NSDictionary (RUYelpBusinessReview)

-(NSString *)ruYelpBusinessReviewID
{
    return [self objectForKey:@"id"];
}

-(NSNumber *)ruYelpBusinessReviewRating
{
    return [self objectForKey:@"rating"];
}

-(NSString *)ruYelpBusinessReviewExcerpt
{
    return [self objectForKey:@"excerpt"];
}

-(NSDictionary *)ruYelpBusinessReviewUser
{
    return [self objectForKey:@"user"];
}

-(NSNumber*)ruYelpBusinessReviewTimeStamp
{
    return [self objectForKey:@"time_created"];
}

@end
