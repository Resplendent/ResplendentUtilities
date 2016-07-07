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

	RUScreenHeightType_iPad_512,
	RUScreenHeightType_iPad_1024,
	RUScreenHeightType_iPad_1366,

	RUScreenHeightType__first	= RUScreenHeightType_480,
	RUScreenHeightType__last	= RUScreenHeightType_iPad_1366,
};

static inline RUEnumIsInRangeSynthesization_autoFirstLast(RUScreenHeightType)

static inline RUScreenHeightType RUScreenHeightType__forCurrentScreen()
{
	NSDictionary<NSNumber*,NSNumber*>* screenHeight_to_RUScreenHeightType_mapping =
	@{
	  @(480.0f)		: @(RUScreenHeightType_480),
	  @(568.0f)		: @(RUScreenHeightType_568),
	  @(667.0f)		: @(RUScreenHeightType_667),
	  @(736.0f)		: @(RUScreenHeightType_736),

	  @(512.0f)		: @(RUScreenHeightType_iPad_512),
	  @(1024.0f)	: @(RUScreenHeightType_iPad_1024),
	  @(1366.0f)	: @(RUScreenHeightType_iPad_1366),
	  };

	CGFloat const height =
	(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ?
	 CGRectGetWidth([UIScreen mainScreen].bounds) :
	 CGRectGetHeight([UIScreen mainScreen].bounds));
	NSNumber* RUScreenHeightType_number = [screenHeight_to_RUScreenHeightType_mapping objectForKey:@(height)];
	kRUConditionalReturn_ReturnValue((RUScreenHeightType_number == nil) ||
									 (RUScreenHeightType__isInRange(RUScreenHeightType_number.integerValue) == false),
									 YES,
									 RUScreenHeightType_unknown);
	
	return RUScreenHeightType_number.integerValue;
}





#endif /* RUScreenHeightTypes_h */
