//
//  NSDictionary+RUFBUserResponseObject.m
//  Resplendent
//
//  Created by Benjamin Maer on 6/24/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "NSDictionary+RUFBUserResponseObject.h"

@implementation NSDictionary (RUFBUserResponseObject)

-(NSString *)fbUserFirstName
{
    return [self objectForKey:@"first_name"];
}

-(NSString *)fbUserLastName
{
    return [self objectForKey:@"last_name"];
}

-(NSString *)fbUserName
{
    return [self objectForKey:@"name"];
}

-(NSString *)fbUserUsername
{
    return [self objectForKey:@"username"];
}

-(NSString *)fbUserId
{
    return [self objectForKey:@"id"];
}

@end
