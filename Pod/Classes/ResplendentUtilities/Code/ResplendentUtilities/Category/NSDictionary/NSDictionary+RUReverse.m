//
//  NSDictionary+RUReverse.m
//  Camerama
//
//  Created by Benjamin Maer on 1/1/15.
//  Copyright (c) 2015 Camerama. All rights reserved.
//

#import "NSDictionary+RUReverse.h"





@implementation NSDictionary (RUReverse)

-(nonnull __kindof NSDictionary*)ru_reverseDictionary
{
	NSDictionary* ru_reverseDictionary = [[self class] dictionaryWithObjects:self.allKeys forKeys:self.allValues];
	NSAssert(ru_reverseDictionary.count == self.count, @"unhandled");
	return ru_reverseDictionary;
}

@end
