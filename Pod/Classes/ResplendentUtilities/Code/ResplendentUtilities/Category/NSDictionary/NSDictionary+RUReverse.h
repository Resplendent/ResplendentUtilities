//
//  NSDictionary+RUReverse.h
//  Camerama
//
//  Created by Benjamin Maer on 1/1/15.
//  Copyright (c) 2015 Camerama. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSDictionary<KeyType, ObjectType> (RUReverse)

/**
 Returns an new instance of the receiver's class, that have swapped the keys and objects of the receiver.
 */
-(nonnull __kindof NSDictionary<ObjectType,KeyType>*)ru_reverseDictionary;

@end
