//
//  NSMutableDictionary+RUUtil.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/29/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableDictionary (RUUtil)

-(void)setObjectOrRemoveIfNil:(id)anObject forKey:(id<NSCopying>)aKey;

@end
