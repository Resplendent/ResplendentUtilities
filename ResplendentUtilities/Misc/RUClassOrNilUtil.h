//
//  RUClassOrNilUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 1/17/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUNumberOrNil(num) ([num isKindOfClass:[NSNumber class]] ? num : nil)
#define kRUStringOrNil(str) ([str isKindOfClass:[NSString class]] ? str : nil)

