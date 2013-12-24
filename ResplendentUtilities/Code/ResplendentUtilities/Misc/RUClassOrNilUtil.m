//
//  RUClassOrNilUtil.m
//  Resplendent
//
//  Created by Benjamin Maer on 8/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUClassOrNilUtil.h"
#import <objc/runtime.h>

id __RUClassOrNilUtilFunction(id val, Class valClass)
{
    //Test if val object is is an instance or a class.
    if(class_isMetaClass(object_getClass(val)))
    {
        //Is a class
        return (val && (val == valClass || [val isSubclassOfClass:valClass]) ? val : nil);
    }
    else
    {
        //Is an instance
        return (val && [val isKindOfClass:valClass] ? val : nil);
    }
}
