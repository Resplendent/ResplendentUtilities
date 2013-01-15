//
//  RUSingleton.h
//  Everycam
//
//  Created by Benjamin Maer on 12/9/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#define RU_SYNTHESIZE_SINGLETON_DECLARATION_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
+(classname *)accessorMethodName;


#define RU_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(classname, accessorMethodName) \
\
static classname *accessorMethodName##Instance = nil; \
\
+ (classname *)accessorMethodName \
{ \
    @synchronized(self) \
    { \
        if (accessorMethodName##Instance == nil) \
        { \
            accessorMethodName##Instance = [self new]; \
        } \
    } \
    \
    return accessorMethodName##Instance; \
}