//
//  RUOrderedDictionary.h
//  Pods
//
//  Created by Benjamin Maer on 2/10/16.
//
//

#import <Foundation/Foundation.h>





@class RUOrderedMutableDictionary<KeyType, ObjectType>;





@interface RUOrderedDictionary<KeyType, ObjectType> : NSDictionary<KeyType, ObjectType>

#pragma mark - NSObject
-(BOOL)isEqual:(nullable id)object;

#pragma mark - Is Equal
-(BOOL)isEqualToRUOrderedDictionary:(nonnull RUOrderedDictionary<KeyType, ObjectType>*)orderedDictionary;

#pragma mark - NSDictionary
-(nonnull instancetype)initWithObjects:(nonnull NSArray *)objects forKeys:(nonnull NSArray<id<NSCopying>> *)keys NS_DESIGNATED_INITIALIZER;

#pragma mark - Index
-(nullable KeyType)keyAtIndex:(NSUInteger)index;
-(nullable ObjectType)objectAtIndex:(NSUInteger)index;

#pragma mark - Enumeration
-(void)enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, KeyType _Nonnull key, ObjectType _Nonnull obj, BOOL  * _Nonnull stop))block;

#pragma mark - NSObject: Copying
-(nonnull instancetype)copy;
-(nonnull RUOrderedMutableDictionary<KeyType, ObjectType>*)mutableCopy;

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedDictionary_performUnitTestOn:(nonnull RUOrderedDictionary*)orderedDictionary
					 againstKeyAndValueArray:(nonnull NSArray*)keyAndValueArray
								   lastValue:(NSInteger)lastValue
								  startValue:(NSInteger)startValue;
#endif

@end
