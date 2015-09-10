//
//  RUConditionalReturn.h
//  Shimmur
//
//  Created by Benjamin Maer on 7/29/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





#define kRUConditionalReturn(condition,assert) \
if (condition) { \
	NSCAssert((!assert),@"Failed condition"); \
	return; \
}

#define kRUConditionalReturn_AlertView(condition,assert,alertView,silent) \
if (condition) { \
	if ((alertView != nil) && \
		(silent == FALSE)) \
	{ \
		[alertView show]; \
	} \
	NSCAssert((!assert),@"Failed condition"); \
	return; \
}



#define kRUConditionalReturn_ReturnValue(condition,assert,returnValue) \
if (condition) { \
NSCAssert((!assert),@"Failed condition"); \
return returnValue; \
}

#define kRUConditionalReturn_ReturnValueNil(condition,assert) \
kRUConditionalReturn_ReturnValue(condition,assert,nil)

#define kRUConditionalReturn_ReturnValueFalse(condition,assert) \
kRUConditionalReturn_ReturnValue(condition,assert,false)

#define kRUConditionalReturn_ReturnValueTrue(condition,assert) \
kRUConditionalReturn_ReturnValue(condition,assert,true)

#define kRUConditionalReturn_AlertView_ReturnValue(condition,assert,alertView,returnValue) \
if (condition) { \
	NSCAssert((!assert),@"Failed condition"); \
	if (alertView != nil) \
	{ \
		[alertView show]; \
	} \
	return returnValue; \
}
