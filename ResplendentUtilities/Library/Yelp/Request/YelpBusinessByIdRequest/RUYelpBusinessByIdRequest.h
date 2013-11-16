//
//  RUYelpBusinessByIdRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUJsonRequest.h"
#import "RUYelpBusinessByIdRequestProtocols.h"

@interface RUYelpBusinessByIdRequest : RUJsonRequest

@property (nonatomic, assign) id<RUYelpBusinessByIdRequestDelegate> delegate;

-(void)fetchWithId:(NSString*)yelpBusinessId;

@end
