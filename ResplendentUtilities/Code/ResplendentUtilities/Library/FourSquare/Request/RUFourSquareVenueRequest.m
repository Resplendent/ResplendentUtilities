//
//  RUFourSquareVenueRequest.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenueRequest.h"
#import "RUFourSquareVenueRequestUtil.h"
#import "RUFourSquareVenueResponse.h"

@implementation RUFourSquareVenueRequest

#pragma mark - Overloaded
+(Class)responseClass
{
    return [RUFourSquareVenueResponse class];
}

#pragma mark - Public methods
-(void)fetchWithFourSquareVenueId:(NSString*)fourSquareVenueId
{
    if (!fourSquareVenueId.length)
        [NSException raise:NSInvalidArgumentException format:@"Need a non nil fourSquareVenueId"];
    
    _fourSquareVenueId = fourSquareVenueId;
    
    NSString* urlString = [RUFourSquareVenueRequestUtil urlForVenueWithId:fourSquareVenueId];
    
    [self fetchWithUrl:[NSURL URLWithString:urlString]];
}

@end
