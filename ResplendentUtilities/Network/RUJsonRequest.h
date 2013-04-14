//
//  RUJsonRequest.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/14/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUNetworkRequest.h"

@interface RUJsonRequest : RUNetworkRequest

-(void)didFinishRequestWithJsonResponse:(id)responseJson;

@end
