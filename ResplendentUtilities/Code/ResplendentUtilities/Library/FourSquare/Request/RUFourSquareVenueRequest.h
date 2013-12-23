//
//  RUFourSquareVenueRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareRequest.h"

@interface RUFourSquareVenueRequest : RUFourSquareRequest

@property (nonatomic, readonly) NSString* fourSquareVenueId;
//@property (nonatomic, assign) id<PAFourSquareVenueRequestDelegate> delegate;

-(void)fetchWithFourSquareVenueId:(NSString*)fourSquareVenueId;

@end
