//
//  RUProtocolOrNil.h
//  Resplendent
//
//  Created by Benjamin Maer on 5/14/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUProtocolOrNil(val,valProtocol) (val && [val conformsToProtocol:@protocol(valProtocol)] ? (id<valProtocol>)val : nil)
