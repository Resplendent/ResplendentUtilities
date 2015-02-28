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





@interface RUOrderedMutableDictionary ()

@property (nonatomic, readonly) NSMutableDictionary* dictionary;
@property (nonatomic, readonly) NSMutableArray* array;

+(BOOL)RUOrderedMutableDictionary_performUnitTest;

@end





@implementation RUOrderedMutableDictionary

@synthesize dictionary = _dictionary;
@synthesize array = _array;

+(void)initialize
{
	NSAssert([self RUOrderedMutableDictionary_performUnitTest], @"Failed unit test!");
}

- (id)initWithCapacity:(NSUInteger)capacity
{
	if (self = [super init])
    {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
        _array = [NSMutableArray arrayWithCapacity:capacity];
    }

    return self;
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    if (![self.dictionary objectForKey:aKey])
    {
        [self.array addObject:aKey];
    }

    [self.dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [self.dictionary removeObjectForKey:aKey];
    [self.array removeObject:aKey];
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
    return [self.array objectEnumerator];
}

#pragma mark - Getters
-(NSMutableDictionary *)dictionary
{
    if (!_dictionary)
    {
        _dictionary = [NSMutableDictionary dictionary];
    }

    return _dictionary;
}

-(NSMutableArray *)array
{
    if (!_array)
    {
        _array = [NSMutableArray array];
    }

    return _array;
}

#pragma mark - Unit Testing
+(BOOL)RUOrderedMutableDictionary_performUnitTest
{
	static NSInteger const count = 1000;

	RUOrderedMutableDictionary* orderedMutableDictionary = [RUOrderedMutableDictionary new];

	for (NSInteger i = 0; i < count; i++)
	{
		[orderedMutableDictionary setObject:@(i) forKey:@(i)];
	}

	NSInteger lastKeyNumber = NSNotFound;

	for (NSNumber* key in orderedMutableDictionary)
	{
		kRUConditionalReturn_ReturnValueFalse(!kRUNumberOrNil(key), YES);
		
		NSInteger keyNumber = key.integerValue;
		kRUConditionalReturn_ReturnValueFalse(((lastKeyNumber != NSNotFound) &&
											   (lastKeyNumber != (keyNumber - 1))), YES);

		NSNumber* value = kRUNumberOrNil([orderedMutableDictionary objectForKey:key]);
		kRUConditionalReturn_ReturnValueFalse(value == nil, YES);
		
		kRUConditionalReturn_ReturnValueFalse(value.integerValue != keyNumber, YES);

		lastKeyNumber = keyNumber;
	}

	return YES;
}

@end
