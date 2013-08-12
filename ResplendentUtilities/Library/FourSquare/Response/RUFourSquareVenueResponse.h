//
//  RUFourSquareVenueResponse.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareResponse.h"

@class RUFourSquareVenue;

@interface RUFourSquareVenueResponse : RUFourSquareResponse

@property (nonatomic, readonly) RUFourSquareVenue* venue;

@end
