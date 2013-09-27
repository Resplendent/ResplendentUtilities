//
//  RUYelpSearchBusinessesRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUJsonRequest.h"
#import "RUYelpSearchBusinessesRequestProtocols.h"

@interface RUYelpSearchBusinessesRequest : RUJsonRequest

@property (nonatomic, assign) id<RUYelpSearchBusinessesRequestDelegate> delegate;

-(void)fetchWithLatitude:(double)latitude longitude:(double)longitude searchTerm:(NSString*)searchTerm;

@end
