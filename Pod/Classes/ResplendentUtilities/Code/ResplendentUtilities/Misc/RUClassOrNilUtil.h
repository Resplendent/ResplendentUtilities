//
//  RUClassOrNilUtil.h
//  Resplendent
//
//  Created by Benjamin Maer on 8/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>


id __RUClassOrNilUtilFunction(id val, Class valClass);

#define kRUClassOrNil(val,valClass) ((valClass*)__RUClassOrNilUtilFunction(val,[valClass class]))
#define kRUNumberOrNil(num) kRUClassOrNil(num,NSNumber)
#define kRUStringOrNil(str) kRUClassOrNil(str,NSString)
#define kRUDictionaryOrNil(dict) kRUClassOrNil(dict,NSDictionary)
