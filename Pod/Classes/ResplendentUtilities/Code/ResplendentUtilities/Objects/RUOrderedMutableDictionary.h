//
//  RUOrderedMutableDictionary.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/16/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface RUOrderedMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>

#pragma mark - Index
-(nullable KeyType)keyAtIndex:(NSUInteger)index;
-(nullable ObjectType)objectAtIndex:(NSUInteger)index;

#pragma mark - Enumeration
-(void)enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, KeyType _Nonnull key, ObjectType _Nonnull obj, BOOL  * _Nonnull stop))block;

@end
