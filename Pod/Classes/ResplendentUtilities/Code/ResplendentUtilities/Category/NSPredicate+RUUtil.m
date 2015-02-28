//
//  NSPredicate+RUUtil.m
//  Shimmur
//
//  Created by Benjamin Maer on 12/10/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSPredicate+RUUtil.h"
#import "RUConditionalReturn.h"





@implementation NSPredicate (RUUtil)

+(instancetype)ru_predicateWithSearchText:(NSString*)searchText properties:(NSArray*)properties
{
	kRUConditionalReturn_ReturnValueNil(searchText.length == 0, YES);
	kRUConditionalReturn_ReturnValueNil(properties.count == 0, YES);
	
	NSArray* searchTerms = [searchText componentsSeparatedByString:@" "];

	NSMutableArray* predicateFormatComponents = [NSMutableArray arrayWithCapacity:properties.count];
	for (int i = 0; i < properties.count; i++)
	{
		[predicateFormatComponents addObject:@"(%K CONTAINS[cd] %@)"];
	}

	NSString* predicateFormat = [predicateFormatComponents componentsJoinedByString:@" OR "];
	
	if (searchTerms.count == 1)
	{
		NSString *term = [searchTerms firstObject];

		NSMutableArray* argumentArray = [NSMutableArray arrayWithCapacity:properties.count * 2];
		for (NSString* property in properties)
		{
			[argumentArray addObject:property];
			[argumentArray addObject:term];
		}

		return [NSPredicate predicateWithFormat:predicateFormat argumentArray:argumentArray];
	}
	else
	{
		NSMutableArray *subPredicates = [NSMutableArray array];
		for (NSString *term in searchTerms) {
			if (term.length > 0)
			{
				NSMutableArray* argumentArray = [NSMutableArray arrayWithCapacity:properties.count * 2];
				for (NSString* property in properties)
				{
					[argumentArray addObject:property];
					[argumentArray addObject:term];
				}

				NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat argumentArray:argumentArray];
				[subPredicates addObject:predicate];
			}
		}

		return [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
	}
}

@end
