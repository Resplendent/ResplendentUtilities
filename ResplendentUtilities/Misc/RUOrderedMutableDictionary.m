//
//  RUOrderedMutableDictionary.m
//  LENS
//
//  Created by Benjamin Maer on 10/16/13.
//  Copyright (c) 2013 Novella. All rights reserved.
//

#import "RUOrderedMutableDictionary.h"

@interface RUOrderedMutableDictionary ()

@property (nonatomic, readonly) NSMutableDictionary* dictionary;
@property (nonatomic, readonly) NSMutableArray* array;

@end

@implementation RUOrderedMutableDictionary

@synthesize dictionary = _dictionary;
@synthesize array = _array;

- (id)initWithCapacity:(NSUInteger)capacity
{
    if (self = [self init])
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

@end
