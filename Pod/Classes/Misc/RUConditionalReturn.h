//
//  RUConditionalReturn.h
//  Shimmur
//
//  Created by Benjamin Maer on 7/29/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





/**
 This macro is meant for handling the shared assertion logic. Note that this macro expects a condition as a parameter, which if true will crash fail an assertion, which is the opposite boolean logic of what an assertion expects.

 @param assert The condition to test. If the condition evalues to `TRUE`, then an assertion is failed, and an exception will be thrown.
 */
#define kRUConditionalReturn__assertion(assert) NSCAssert(!(assert),@"Failed condition");

#define kRUConditionalReturn(condition,assert) \
if (condition) { \
	kRUConditionalReturn__assertion(assert); \
	return; \
}

#define kRUConditionalReturn_AlertView(condition,assert,alertView,silent) \
if (condition) { \
	if ((alertView != nil) && \
		(silent == FALSE)) \
	{ \
		[alertView show]; \
	} \
	kRUConditionalReturn__assertion(assert); \
	return; \
}



#define kRUConditionalReturn_ReturnValue(condition,assert,returnValue) \
if (condition) { \
kRUConditionalReturn__assertion(assert); \
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
	kRUConditionalReturn__assertion(assert); \
	if (alertView != nil) \
	{ \
		[alertView show]; \
	} \
	return returnValue; \
}
