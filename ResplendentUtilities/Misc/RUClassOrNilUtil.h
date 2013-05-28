//
//  RUClassOrNilUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 1/17/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUClassOrNil(val,valClass) (val && [val isKindOfClass:[valClass class]] ? (valClass*)val : nil)
#define kRUNumberOrNil(num) kRUClassOrNil(num,NSNumber)
#define kRUStringOrNil(str) kRUClassOrNil(str,NSString)
#define kRUDictionaryOrNil(dict) kRUClassOrNil(dict,NSDictionary)

