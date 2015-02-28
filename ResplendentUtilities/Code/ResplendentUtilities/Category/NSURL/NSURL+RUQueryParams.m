//
//  NSURL+RUQueryParams.m
//  Camerama
//
//  Created by Benjamin Maer on 12/19/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "NSURL+RUQueryParams.h"
#import "NSString+RUURLParams.h"





@implementation NSURL (RUQueryParams)

-(NSDictionary *)ru_queryParams
{
	NSString* properQueryString = [[self query]stringByRemovingPercentEncoding];

	return [properQueryString ru_URLParams];
}

@end
