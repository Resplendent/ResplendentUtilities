//
//  RUSingleton.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/9/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#define CMRASingletonUtil_Synthesize_Singleton_Implementation(methodName) \
+(instancetype)methodName \
{ \
	static id sharedInstance; \
	 \
__CMRASingletonUtil_Synthesize_Singleton_Implementation__Body(sharedInstance) \
	return sharedInstance; \
}

#define __CMRASingletonUtil_Synthesize_Singleton_Implementation__Body(staticVarName) \
	@synchronized (self) \
	{ \
		static dispatch_once_t onceToken; \
		dispatch_once(&onceToken, ^{ \
			staticVarName = [self new]; \
		}); \
	} \
