//
//  RUFourSquareVenueSearchRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareRequest.h"

@interface RUFourSquareVenueSearchRequest : RUFourSquareRequest

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

-(void)fetchWithLatitude:(double)latitude longitude:(double)longitude limit:(NSInteger)limit;

@end
