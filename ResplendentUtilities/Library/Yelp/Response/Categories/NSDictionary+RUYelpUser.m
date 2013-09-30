//
//  NSDictionary+RUYelpUser.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/28/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "NSDictionary+RUYelpUser.h"

@implementation NSDictionary (RUYelpUser)

-(NSString *)ruYelpUserId
{
    return [self objectForKey:@"id"];
}

-(NSString *)ruYelpUserImageUrl
{
    return [self objectForKey:@"image_url"];
}

-(NSString *)ruYelpUserName
{
    return [self objectForKey:@"name"];
}

@end
