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
	NSAssert((!assert),@"Failed condition"); \
	return; \
}

#define kRUConditionalReturn_AlertView(condition,assert,alertView,silent) \
if (condition) { \
	if ((alertView != nil) && \
		(silent == FALSE)) \
	{ \
		[alertView show]; \
	} \
	NSAssert((!assert),@"Failed condition"); \
	return; \
}
