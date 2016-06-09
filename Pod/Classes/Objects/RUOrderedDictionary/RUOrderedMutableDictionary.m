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
#import "RUOrderedDictionary.h"





@interface RUOrderedMutableDictionary<KeyType, ObjectType> ()

#pragma mark - ru_dictionary
@property (nonatomic, readonly, nonnull) NSMutableDictionary<KeyType, ObjectType>* ru_dictionary;

#pragma mark - ru_keysArray
@property (nonatomic, readonly, nonnull) NSMutableArray<KeyType>* ru_keysArray;

#pragma mark - ru_valuesArray
@property (nonatomic, readonly, nonnull) NSMutableArray<ObjectType>* ru_valuesArray;

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedMutableDictionary_performUnitTest;
#endif

@end





@implementation RUOrderedMutableDictionary

#pragma mark - NSObject
+(void)initialize
{
	NSAssert([self RUOrderedMutableDictionary_performUnitTest], @"Failed unit test!");
}

-(BOOL)isEqual:(nullable id)object
{
	kRUConditionalReturn_ReturnValueFalse(object == false, NO);

	return [self isEqualToRUOrderedMutableDictionary:object];
}

#pragma mark - Is Equal
-(BOOL)isEqualToRUOrderedMutableDictionary:(nonnull RUOrderedMutableDictionary*)orderedMutableDictionary
{
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary == nil, YES);
	kRUConditionalReturn_ReturnValueTrue(self == orderedMutableDictionary, NO);

	kRUConditionalReturn_ReturnValueFalse(kRUClassOrNil(orderedMutableDictionary, RUOrderedMutableDictionary) == nil, NO);

	kRUConditionalReturn_ReturnValueFalse([self.ru_dictionary isEqualToDictionary:orderedMutableDictionary.ru_dictionary] == false, NO);
	kRUConditionalReturn_ReturnValueFalse([self.ru_keysArray isEqualToArray:orderedMutableDictionary.ru_keysArray] == false, NO);
	kRUConditionalReturn_ReturnValueFalse([self.ru_valuesArray isEqualToArray:orderedMutableDictionary.ru_valuesArray] == false, NO);

	return YES;
}

#pragma mark - NSMutableDictionary
-(id)initWithCapacity:(NSUInteger)capacity
{
	if (self = [super init])
    {
        _ru_dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
        _ru_keysArray = [NSMutableArray arrayWithCapacity:capacity];
		_ru_valuesArray = [NSMutableArray arrayWithCapacity:capacity];
    }

    return self;
}

-(nonnull instancetype)initWithObjects:(nonnull NSArray *)objects forKeys:(nonnull NSArray<id<NSCopying>> *)keys
{
	if (self = [super init])
	{
		_ru_dictionary = [[NSMutableDictionary alloc]initWithObjects:objects forKeys:keys];
		_ru_keysArray = [keys mutableCopy];
		_ru_valuesArray = [objects mutableCopy];
	}

	return self;
}

-(void)setObject:(id)anObject forKey:(id)aKey
{
    if ([self.ru_dictionary objectForKey:aKey] == false)
    {
		[self.ru_keysArray addObject:aKey];
		[self.ru_valuesArray addObject:anObject];
    }

    [self.ru_dictionary setObject:anObject forKey:aKey];
}

-(void)removeObjectForKey:(id)aKey
{
	NSUInteger indexOfKey = [self ru_indexOfKey:aKey];
	BOOL indexOfKey_isValid = (indexOfKey < self.ru_keysArray.count);
	if (indexOfKey_isValid)
	{
		NSAssert(([[self objectForKey:aKey] isEqual:[self ru_objectAtIndex:indexOfKey]]),
				 @"aKey '%@' at index `%lu` had object `%@` that didn't match values array object %@",aKey,(unsigned long)indexOfKey,
				 [self objectForKey:aKey],
				 [self ru_objectAtIndex:indexOfKey]);

		[self.ru_keysArray removeObjectAtIndex:indexOfKey];
		[self.ru_valuesArray removeObjectAtIndex:indexOfKey];
	}

	[self.ru_dictionary removeObjectForKey:aKey];
}

-(NSUInteger)count
{
    return [self.ru_dictionary count];
}

-(id)objectForKey:(id)aKey
{
    return [self.ru_dictionary objectForKey:aKey];
}

-(NSEnumerator*)keyEnumerator
{
    return [self.ru_keysArray objectEnumerator];
}

-(NSArray*)allKeys
{
	return [self.ru_keysArray copy];
}

-(NSArray*)allValues
{
	return [self.ru_valuesArray copy];
}

#pragma mark - Custom Init
-(nonnull instancetype)initWithRUOrderedDictionary:(nonnull RUOrderedDictionary*)orderedDictionary
{
	return (self = [self initWithObjects:orderedDictionary.allValues
								 forKeys:orderedDictionary.allKeys]);
}

-(nonnull instancetype)initWithRUOrderedMutableDictionary:(nonnull RUOrderedMutableDictionary*)orderedMutableDictionary
{
	return (self = [self initWithObjects:orderedMutableDictionary.allValues
								 forKeys:orderedMutableDictionary.allKeys]);
}

#pragma mark - ru_dictionary
@synthesize ru_dictionary = _ru_dictionary;
-(NSMutableDictionary*)ru_dictionary
{
    if (!_ru_dictionary)
    {
        _ru_dictionary = [NSMutableDictionary dictionary];
    }

    return _ru_dictionary;
}

#pragma mark - ru_keysArray
@synthesize ru_keysArray = _ru_keysArray;
-(NSMutableArray*)ru_keysArray
{
	if (!_ru_keysArray)
	{
		_ru_keysArray = [NSMutableArray array];
	}

	return _ru_keysArray;
}

#pragma mark - ru_valuesArray
@synthesize ru_valuesArray = _ru_valuesArray;
-(NSMutableArray*)ru_valuesArray
{
	if (!_ru_valuesArray)
	{
		_ru_valuesArray = [NSMutableArray array];
	}

	return _ru_valuesArray;
}

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedMutableDictionary_performUnitTest
{
	static NSInteger const lastValue = 100;
	static NSInteger const startValue = -lastValue;

	NSMutableArray<NSNumber*>* orderedNumbers_mutable = [NSMutableArray array];
	for (NSInteger i = startValue;
		 i <= lastValue;
		 i++)
	{
		[orderedNumbers_mutable addObject:@(i)];
	}

	kRUConditionalReturn_ReturnValueFalse(orderedNumbers_mutable.count != (1 + lastValue - startValue), YES);

	NSArray<NSNumber*>* orderedNumbers = [orderedNumbers_mutable copy];

	// looping, with capacity
	RUOrderedMutableDictionary<NSNumber*,NSNumber*>* orderedMutableDictionary_looping = [RUOrderedMutableDictionary dictionaryWithCapacity:orderedNumbers.count];
	kRUConditionalReturn_ReturnValueFalse((orderedMutableDictionary_looping == nil), YES);

	[orderedNumbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[orderedMutableDictionary_looping setObject:obj forKey:obj];
	}];
	kRUConditionalReturn_ReturnValueFalse((orderedMutableDictionary_looping.count != orderedNumbers.count), YES);

	// staticConstructor
	RUOrderedMutableDictionary* orderedDictionary_staticConstructor = [RUOrderedMutableDictionary dictionaryWithObjects:orderedNumbers
																												forKeys:orderedNumbers];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_staticConstructor == nil), YES);

	// instanceConstructor
	RUOrderedMutableDictionary* orderedDictionary_instanceConstructor = [[RUOrderedMutableDictionary alloc]initWithObjects:orderedNumbers
																												   forKeys:orderedNumbers];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor == nil), YES);

	// mutable copy
	RUOrderedMutableDictionary* orderedDictionary_instanceConstructor_mutableCopy = [orderedDictionary_instanceConstructor mutableCopy];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor_mutableCopy == nil), YES);

	NSArray<RUOrderedDictionary*>* orderedDictionariesToTest = @[
																 orderedMutableDictionary_looping,
																 orderedDictionary_staticConstructor,
																 orderedDictionary_instanceConstructor,
																 orderedDictionary_instanceConstructor_mutableCopy,
																 ];

	for (RUOrderedMutableDictionary* orderedDictionaryToTest in orderedDictionariesToTest)
	{
		kRUConditionalReturn_ReturnValueFalse(([self RUOrderedMutableDictionary_performUnitTestOn:orderedDictionaryToTest
																		  againstKeyAndValueArray:orderedNumbers
																						lastValue:lastValue
																					   startValue:startValue] == false), YES);
	}

	// copy
	RUOrderedDictionary* orderedDictionary_instanceConstructor_copy = [orderedDictionary_instanceConstructor copy];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor_copy == nil), YES);
	kRUConditionalReturn_ReturnValueFalse([RUOrderedDictionary RUOrderedDictionary_performUnitTestOn:orderedDictionary_instanceConstructor_copy
																			 againstKeyAndValueArray:orderedNumbers
																						   lastValue:lastValue
																						  startValue:startValue] == false, YES);

	return YES;
}

+(BOOL)RUOrderedMutableDictionary_performUnitTestOn:(nonnull RUOrderedMutableDictionary*)orderedMutableDictionary
							againstKeyAndValueArray:(nonnull NSArray*)keyAndValueArray
										  lastValue:(NSInteger)lastValue
										 startValue:(NSInteger)startValue
{
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary == nil, YES);
	kRUConditionalReturn_ReturnValueFalse(keyAndValueArray == nil, YES);

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
	[orderedMutableDictionary ru_enumerateIndexesKeysAndObjectsUsingBlock:^(NSUInteger index, NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {

		if ((key.integerValue != (index + startValue)) ||
			(validateNextNumberAndAdvance(key,obj) == false))
		{
			NSAssert(false, @"enumerationFailed for key %@ and obj %@",key,obj);
			enumerationFailed = YES;
			*stop = YES;
		}

	}];

	kRUConditionalReturn_ReturnValueFalse(enumerationFailed == true, YES);

	RUOrderedMutableDictionary* orderedMutableDictionary_mutableCopyToRemoveFrom = [orderedMutableDictionary mutableCopy];
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_mutableCopyToRemoveFrom == nil, YES);

	for (id key in orderedMutableDictionary)
	{
		[orderedMutableDictionary_mutableCopyToRemoveFrom removeObjectForKey:key];
	}

	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_mutableCopyToRemoveFrom.count != 0, YES);
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_mutableCopyToRemoveFrom.ru_dictionary.count != 0, YES);
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_mutableCopyToRemoveFrom.ru_keysArray.count != 0, YES);
	kRUConditionalReturn_ReturnValueFalse(orderedMutableDictionary_mutableCopyToRemoveFrom.ru_valuesArray.count != 0, YES);

	return YES;
}
#endif

#pragma mark - Index
-(NSUInteger)ru_indexOfKey:(nonnull id)key
{
	return [self.ru_keysArray indexOfObject:key];
}

-(nullable id)ru_keyAtIndex:(NSUInteger)index
{
	return [self.ru_keysArray objectAtIndex:index];
}

-(nullable id)ru_objectAtIndex:(NSUInteger)index
{
	return [self.ru_valuesArray objectAtIndex:index];
}

#pragma mark - Enumeration
-(void)ru_enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, id _Nonnull key, id _Nonnull obj, BOOL  * _Nonnull stop))block
{
	kRUConditionalReturn(block == nil, YES);

	[self.ru_keysArray enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
		block(idx,key,[self objectForKey:key],stop);
	}];
}

#pragma mark - NSObject: Copying
-(nonnull RUOrderedDictionary*)copy
{
	return [RUOrderedDictionary dictionaryWithObjects:self.allValues
											  forKeys:self.allKeys];
}

-(nonnull instancetype)mutableCopy
{
	return [[[self class]alloc]initWithRUOrderedMutableDictionary:self];
}

@end
