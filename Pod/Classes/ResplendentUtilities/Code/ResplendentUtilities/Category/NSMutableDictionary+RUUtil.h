//
//  NSMutableDictionary+RUUtil.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/29/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableDictionary<KeyType, ObjectType> (RUUtil)

-(void)setObjectOrRemoveIfNil:(ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;

@end
