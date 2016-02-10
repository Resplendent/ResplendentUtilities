//
//  RUOrderedMutableDictionary.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/16/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUOrderedMutableDictionary.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@interface RUOrderedMutableDictionary<KeyType, ObjectType> ()

@property (nonatomic, readonly, nonnull) NSMutableDictionary<KeyType, ObjectType>* dictionary;
@property (nonatomic, readonly, nonnull) NSMutableArray<KeyType>* keysArray;

+(BOOL)RUOrderedMutableDictionary_performUnitTest;

@end





@implementation RUOrderedMutableDictionary

#pragma mark - NSObject
+(void)initialize
{
	NSAssert([self RUOrderedMutableDictionary_performUnitTest], @"Failed unit test!");
}

#pragma mark - NSMutableDictionary
- (id)initWithCapacity:(NSUInteger)capacity
{
	if (self = [super init])
    {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
        _keysArray = [NSMutableArray arrayWithCapacity:capacity];
    }

    return self;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    if (![self.dictionary objectForKey:aKey])
    {
        [self.keysArray addObject:aKey];
    }

    [self.dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [self.dictionary removeObjectForKey:aKey];
    [self.keysArray removeObject:aKey];
}

- (NSUInteger)count
{
    return [self.dictionary count];
}

- (id)objectForKey:(id)aKey
{
    return [self.dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    return [self.keysArray objectEnumerator];
}

#pragma mark - Getters
@synthesize dictionary = _dictionary;
-(NSMutableDictionary *)dictionary
{
    if (!_dictionary)
    {
        _dictionary = [NSMutableDictionary dictionary];
    }

    return _dictionary;
}

@synthesize keysArray = _keysArray;
-(NSMutableArray *)keysArray
{
    if (!_keysArray)
    {
        _keysArray = [NSMutableArray array];
    }

    return _keysArray;
}

#pragma mark - Unit Testing
+(BOOL)RUOrderedMutableDictionary_performUnitTest
{
	static NSInteger const lastValue = 100;
	static NSInteger const startValue = -lastValue;

	RUOrderedMutableDictionary<NSNumber*,NSNumber*>* orderedMutableDictionary = [RUOrderedMutableDictionary new];

	for (NSInteger i = startValue;
		 i <= lastValue;
		 i++)
	{
		[orderedMutableDictionary setObject:@(i) forKey:@(i)];
	}

	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary.count != (1 + lastValue - startValue), YES);

	__block NSInteger lastKeyNumber = NSNotFound;

	void (^reset_lastKeyNumber)() = ^{
		lastKeyNumber = NSNotFound;
	};
	
	BOOL (^validateNextNumberAndAdvance)(NSNumber* _Nonnull nextNumber, NSNumber* _Nullable nextObject) = ^BOOL(NSNumber* _Nonnull nextNumber, NSNumber* _Nullable nextObject)
	{
		kRUConditionalReturn_ReturnValueFalse(kRUNumberOrNil(nextNumber) == nil, YES);
		
		NSInteger keyNumber = nextNumber.integerValue;
		kRUConditionalReturn_ReturnValueFalse(((lastKeyNumber != NSNotFound) &&
											   (lastKeyNumber != (keyNumber - 1))), YES);
		
		NSNumber* orderedMutableDictionary_objectForNextNumber = kRUNumberOrNil([orderedMutableDictionary objectForKey:nextNumber]);
		kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_objectForNextNumber == nil, YES);
		
		kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_objectForNextNumber.integerValue != keyNumber, YES);

		if (nextObject != nil)
		{
			kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_objectForNextNumber.integerValue != nextObject.integerValue, YES);
		}
		
		lastKeyNumber = keyNumber;
		
		return YES;
	};

	//For Loop enumeration
	for (NSNumber* key in orderedMutableDictionary)
	{
		kRUConditionalReturn_ReturnValueFalse(validateNextNumberAndAdvance(key,nil) == false, YES);
	}

	//Native method enumeration
	reset_lastKeyNumber();
	__block BOOL enumerationFailed = false;
	[orderedMutableDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
		if (validateNextNumberAndAdvance(key,obj) == false)
		{
			NSAssert(false, @"enumerationFailed for key %@ and obj %@",key,obj);
			enumerationFailed = YES;
			*stop = YES;
		}
	}];

	kRUConditionalReturn_ReturnValueFalse(enumerationFailed == true, YES);

	//Custom enumeration
	reset_lastKeyNumber();
	[orderedMutableDictionary enumerateIndexesKeysAndObjectsUsingBlock:^(NSUInteger index, NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {

		if ((key.integerValue != (index + startValue)) ||
			(validateNextNumberAndAdvance(key,obj) == false))
		{
			NSAssert(false, @"enumerationFailed for key %@ and obj %@",key,obj);
			enumerationFailed = YES;
			*stop = YES;
		}

	}];

	kRUConditionalReturn_ReturnValueFalse(enumerationFailed == true, YES);

	return YES;
}

#pragma mark - Object At Index
-(nullable id)keyAtIndex:(NSUInteger)index
{
	return [self.keysArray objectAtIndex:index];
}

-(nullable id)objectAtIndex:(NSUInteger)index
{
	return [self objectForKey:[self keyAtIndex:index]];
}

#pragma mark - Enumeration
-(void)enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, id _Nonnull key, id _Nonnull obj, BOOL  * _Nonnull stop))block
{
	kRUConditionalReturn(block == nil, YES);

	[self.keysArray enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
		block(idx,key,[self objectForKey:key],stop);
	}];
}

@end
