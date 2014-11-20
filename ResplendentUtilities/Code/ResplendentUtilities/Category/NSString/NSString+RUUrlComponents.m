//
//  NSString+RUUrlComponents.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 11/3/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "NSString+RUUrlComponents.h"
#import "RUConstants.h"





@implementation NSString (RUUrlComponents)

-(NSString*)ru_urlPathWithUrlParameters:(NSDictionary*)urlParameters
{
	return RUStringWithFormat(@"%@?%@",self,[self.class ru_urlPathComponentsFromUrlParameters:urlParameters]);
}

+(NSString*)ru_urlPathComponentsFromUrlParameters:(NSDictionary*)urlParameters
{
	NSMutableArray* parametersArray = [NSMutableArray arrayWithCapacity:urlParameters.count];
	[urlParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		
		[parametersArray addObject:RUStringWithFormat(@"%@=%@",key,obj)];
		
	}];

	return [parametersArray componentsJoinedByString:@","];
}

@end
