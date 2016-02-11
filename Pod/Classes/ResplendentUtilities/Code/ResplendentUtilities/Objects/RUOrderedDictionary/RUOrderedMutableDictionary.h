//
//  RUOrderedMutableDictionary.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/16/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUOrderedDictionary<KeyType, ObjectType>;





@interface RUOrderedMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>

#pragma mark - NSDictionary
-(nonnull instancetype)initWithCapacity:(NSUInteger)capacity;
-(nonnull instancetype)initWithObjects:(nonnull NSArray<KeyType>*)objects forKeys:(nonnull NSArray<ObjectType<NSCopying>>*)keys;

-(void)setObject:(nonnull ObjectType)anObject forKey:(nonnull KeyType<NSCopying>)aKey;
-(void)removeObjectForKey:(nonnull KeyType<NSCopying>)aKey;
-(NSUInteger)count;
-(nullable ObjectType)objectForKey:(nonnull KeyType)aKey;
-(nonnull NSEnumerator<KeyType>*)keyEnumerator;

-(nonnull NSArray*)allKeys;
-(nonnull NSArray*)allValues;

#pragma mark - Custom Init
-(nonnull instancetype)initWithRUOrderedDictionary:(nonnull RUOrderedDictionary<KeyType, ObjectType>*)orderedDictionary;
-(nonnull instancetype)initWithRUOrderedMutableDictionary:(nonnull RUOrderedMutableDictionary<KeyType, ObjectType>*)orderedMutableDictionary;

#pragma mark - Index
-(NSUInteger)ru_indexOfKey:(nonnull KeyType)key;
-(nullable KeyType)ru_keyAtIndex:(NSUInteger)index;
-(nullable ObjectType)ru_objectAtIndex:(NSUInteger)index;

#pragma mark - Enumeration
-(void)ru_enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, KeyType _Nonnull key, ObjectType _Nonnull obj, BOOL  * _Nonnull stop))block;

#pragma mark - NSObject: Copying
-(nonnull RUOrderedDictionary<KeyType, ObjectType>*)copy;
-(nonnull instancetype)mutableCopy;

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedMutableDictionary_performUnitTestOn:(nonnull RUOrderedMutableDictionary*)orderedMutableDictionary
							againstKeyAndValueArray:(nonnull NSArray*)keyAndValueArray
										  lastValue:(NSInteger)lastValue
										 startValue:(NSInteger)startValue;
#endif

@end
