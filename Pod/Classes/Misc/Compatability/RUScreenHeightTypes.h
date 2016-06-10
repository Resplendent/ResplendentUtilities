//
//  RUScreenHeightTypes.h
//  Pods
//
//  Created by Benjamin Maer on 6/7/16.
//
//

#ifndef RUScreenHeightTypes_h
#define RUScreenHeightTypes_h

#import "RUEnumIsInRangeSynthesization.h"
#import "RUConditionalReturn.h"





typedef NS_ENUM(NSInteger, RUScreenHeightType) {
	RUScreenHeightType_unknown,

	RUScreenHeightType_480,
	RUScreenHeightType_568,
	RUScreenHeightType_667,
	RUScreenHeightType_736,

	RUScreenHeightType__first	= RUScreenHeightType_480,
	RUScreenHeightType__last	= RUScreenHeightType_736,
};

static inline RUEnumIsInRangeSynthesization_autoFirstLast(RUScreenHeightType)

static inline RUScreenHeightType RUScreenHeightType__forCurrentScreen()
{
	NSDictionary<NSNumber*,NSNumber*>* screenHeight_to_RUScreenHeightType_mapping =
	@{
	  @(480.0f)	: @(RUScreenHeightType_480),
	  @(568.0f)	: @(RUScreenHeightType_568),
	  @(667.0f)	: @(RUScreenHeightType_667),
	  @(736.0f)	: @(RUScreenHeightType_736),
	  };
	
	NSNumber* RUScreenHeightType_number = [screenHeight_to_RUScreenHeightType_mapping objectForKey:@(CGRectGetHeight([UIScreen mainScreen].bounds))];
	kRUConditionalReturn_ReturnValue((RUScreenHeightType_number == nil) ||
									 (RUScreenHeightType__isInRange(RUScreenHeightType_number.integerValue) == false),
									 YES,
									 RUScreenHeightType_unknown);
	
	return RUScreenHeightType_number.integerValue;
}





#endif /* RUScreenHeightTypes_h */
