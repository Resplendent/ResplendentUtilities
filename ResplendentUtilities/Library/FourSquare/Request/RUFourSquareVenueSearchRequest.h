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
@property (nonatomic, readonly) NSString* searchText;
@property (nonatomic, readonly) NSInteger limit;

@property (nonatomic, readonly) NSString* urlString;

//param searchText can be nil
-(void)fetchWithSearchText:(NSString*)searchText latitude:(double)latitude longitude:(double)longitude limit:(NSInteger)limit;

@end
