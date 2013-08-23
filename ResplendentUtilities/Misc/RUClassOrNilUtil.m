//
//  RUClassOrNilUtil.m
//  Albumatic
//
//  Created by Benjamin Maer on 8/23/13.
//  Copyright (c) 2013 Albumatic Inc. All rights reserved.
//

#import "RUClassOrNilUtil.h"

id __RUClassOrNilUtilFunction(id val, Class valClass)
{
    return (val && [val isKindOfClass:valClass] ? val : nil);
}
