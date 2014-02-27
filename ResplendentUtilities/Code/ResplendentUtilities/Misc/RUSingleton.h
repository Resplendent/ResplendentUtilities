//
//  RUSingleton.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/9/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#define RU_SYNTHESIZE_SINGLETON_DECLARATION_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
+(classname *)accessorMethodName;


#define RU_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
\
+ (classname *)accessorMethodName \
{ \
    static classname* __accessorMethodName##Instance = nil; \
    static dispatch_once_t __accessorMethodName##InstanceOnceToken; \
    dispatch_once(&__accessorMethodName##InstanceOnceToken, ^{ \
        __accessorMethodName##Instance = [self new]; \
    }); \
    \
    return __accessorMethodName##Instance; \
}
