//
//  RUOrderedDictionary.m
//  Pods
//
//  Created by Benjamin Maer on 2/10/16.
//
//

#import "RUOrderedDictionary.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"
#import "RUOrderedMutableDictionary.h"





@interface RUOrderedDictionary<KeyType, ObjectType> ()

#pragma mark - ru_dictionary
@property (nonatomic, readonly, nonnull) NSDictionary<KeyType, ObjectType>* ru_dictionary;

#pragma mark - ru_keysArray
@property (nonatomic, readonly, nonnull) NSArray<KeyType>* ru_keysArray;

#pragma mark - ru_valuesArray
@property (nonatomic, readonly, nonnull) NSArray<ObjectType>* ru_valuesArray;

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedDictionary_performUnitTest;
#endif

@end





@implementation RUOrderedDictionary

#pragma mark - NSObject
+(void)initialize
{
	NSAssert([self RUOrderedDictionary_performUnitTest], @"Failed unit test!");
}

-(BOOL)isEqual:(nullable id)object
{
	kRUConditionalReturn_ReturnValueFalse(object == false, NO);

	return [self isEqualToRUOrderedDictionary:object];
}

#pragma mark - Is Equal
-(BOOL)isEqualToRUOrderedDictionary:(nonnull RUOrderedDictionary*)orderedDictionary
{
	kRUConditionalReturn_ReturnValueFalse(orderedDictionary == nil, YES);
	kRUConditionalReturn_ReturnValueTrue(self == orderedDictionary, NO);

	kRUConditionalReturn_ReturnValueFalse(kRUClassOrNil(orderedDictionary, RUOrderedDictionary) == nil, NO);

	kRUConditionalReturn_ReturnValueFalse([self.ru_dictionary isEqualToDictionary:orderedDictionary.ru_dictionary] == false, NO);
	kRUConditionalReturn_ReturnValueFalse([self.ru_keysArray isEqualToArray:orderedDictionary.ru_keysArray] == false, NO);
	kRUConditionalReturn_ReturnValueFalse([self.ru_valuesArray isEqualToArray:orderedDictionary.ru_valuesArray] == false, NO);

	return YES;
}

#pragma mark - NSDictionary
-(instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys
{
	if (self = [super init])
	{
		_ru_dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		_ru_keysArray = [keys copy];
		_ru_valuesArray = [objects copy];
	}

	return self;
}

- (instancetype)init
{
	return (self = [self initWithObjects:@[]
								 forKeys:@[]]);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
	return (self = [self initWithObjects:@[]
								 forKeys:@[]]);
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
	return (self = [self initWithObjects:@[]
								 forKeys:@[]]);
}

- (NSUInteger)count
{
	return [self.ru_dictionary count];
}

- (id)objectForKey:(id)aKey
{
	return [self.ru_dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
	return [self.ru_keysArray objectEnumerator];
}

#pragma mark - ru_dictionary
@synthesize ru_dictionary = _ru_dictionary;
-(NSDictionary*)ru_dictionary
{
	if (!_ru_dictionary)
	{
		_ru_dictionary = [NSDictionary dictionary];
	}

	return _ru_dictionary;
}

#pragma mark - ru_keysArray
@synthesize ru_keysArray = _ru_keysArray;
-(NSArray*)ru_keysArray
{
	if (!_ru_keysArray)
	{
		_ru_keysArray = [NSArray array];
	}

	return _ru_keysArray;
}

#pragma mark - ru_valuesArray
@synthesize ru_valuesArray = _ru_valuesArray;
-(NSArray*)ru_valuesArray
{
	if (!_ru_valuesArray)
	{
		_ru_valuesArray = [NSArray array];
	}

	return _ru_valuesArray;
}

#if DEBUG
#pragma mark - Unit Testing
+(BOOL)RUOrderedDictionary_performUnitTest
{
	kRUConditionalReturn_ReturnValueFalse(self != [self copy], YES);

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

	// staticConstructor
	RUOrderedDictionary* orderedDictionary_staticConstructor = [RUOrderedDictionary dictionaryWithObjects:orderedNumbers
																								  forKeys:orderedNumbers];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_staticConstructor == nil), YES);

	// instanceConstructor
	RUOrderedDictionary* orderedDictionary_instanceConstructor = [[RUOrderedDictionary alloc]initWithObjects:orderedNumbers
																									 forKeys:orderedNumbers];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor == nil), YES);

	// copy
	RUOrderedDictionary* orderedDictionary_instanceConstructor_copy = [orderedDictionary_instanceConstructor copy];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor_copy == nil), YES);

	NSArray<RUOrderedDictionary*>* orderedDictionariesToTest = @[
																 orderedDictionary_staticConstructor,
																 orderedDictionary_instanceConstructor,
																 orderedDictionary_instanceConstructor_copy,
																 ];

	for (RUOrderedDictionary* orderedDictionaryToTest in orderedDictionariesToTest)
	{
		kRUConditionalReturn_ReturnValueFalse(([self RUOrderedDictionary_performUnitTestOn:orderedDictionaryToTest
																   againstKeyAndValueArray:orderedNumbers
																				 lastValue:lastValue
																				startValue:startValue] == false), YES);
	}

	// mutable copy
	RUOrderedMutableDictionary* orderedDictionary_instanceConstructor_mutableCopy = [orderedDictionary_instanceConstructor mutableCopy];
	kRUConditionalReturn_ReturnValueFalse((orderedDictionary_instanceConstructor_mutableCopy == nil), YES);

	kRUConditionalReturn_ReturnValueFalse([RUOrderedMutableDictionary RUOrderedMutableDictionary_performUnitTestOn:orderedDictionary_instanceConstructor_mutableCopy
																						   againstKeyAndValueArray:orderedNumbers
																										 lastValue:lastValue
																										startValue:startValue] == false, YES);

	return YES;
}

+(BOOL)RUOrderedDictionary_performUnitTestOn:(nonnull RUOrderedDictionary*)orderedDictionary
					 againstKeyAndValueArray:(nonnull NSArray*)keyAndValueArray
								   lastValue:(NSInteger)lastValue
								  startValue:(NSInteger)startValue
{
	kRUConditionalReturn_ReturnValueFalse(orderedDictionary == nil, YES);
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

		NSNumber* orderedMutableDictionary_objectForNextNumber = kRUNumberOrNil([orderedDictionary objectForKey:nextNumber]);
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
	for (NSNumber* key in orderedDictionary)
	{
		kRUConditionalReturn_ReturnValueFalse(validateNextNumberAndAdvance(key,nil) == false, YES);
	}

	//Native method enumeration
	reset_lastKeyNumber();
	__block BOOL enumerationFailed = false;
	[orderedDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
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
	[orderedDictionary enumerateIndexesKeysAndObjectsUsingBlock:^(NSUInteger index, NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {

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
#endif

#pragma mark - Index
-(nullable id)keyAtIndex:(NSUInteger)index
{
	return [self.ru_keysArray objectAtIndex:index];
}

-(nullable id)objectAtIndex:(NSUInteger)index
{
	return [self.ru_valuesArray objectAtIndex:index];
}

#pragma mark - Enumeration
-(void)enumerateIndexesKeysAndObjectsUsingBlock:(nonnull void (^)(NSUInteger index, id _Nonnull key, id _Nonnull obj, BOOL  * _Nonnull stop))block
{
	kRUConditionalReturn(block == nil, YES);

	[self.ru_keysArray enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
		block(idx,key,[self objectForKey:key],stop);
	}];
}

#pragma mark - NSObject: Copying
-(nonnull instancetype)copy
{
	return self;
}

-(nonnull RUOrderedMutableDictionary*)mutableCopy
{
	return [[RUOrderedMutableDictionary alloc]initWithRUOrderedDictionary:self];
}

@end
