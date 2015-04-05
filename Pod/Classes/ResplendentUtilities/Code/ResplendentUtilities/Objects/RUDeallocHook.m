//
//  RUDeallocHook.m
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUDeallocHook.h"
#import "RUDLog.h"
#import "RUConditionalReturn.h"





@interface RUDeallocHook ()

@property (nonatomic, readonly) RUDeallocHookBlock deallocBlock;

@end





@implementation RUDeallocHook

#pragma mark - NSObject
-(void)dealloc
{
    if (self.deallocBlock)
    {
        self.deallocBlock();
		[self clearBlock];
    }
}

#pragma mark - Contructors
-(id)initWithBlock:(RUDeallocHookBlock)deallocBlock
{
	//No reason to create dealloc hook if not using block
	kRUConditionalReturn_ReturnValueNil(deallocBlock == nil, YES);
	
	if (self = [self init])
	{
		_deallocBlock = deallocBlock;
	}
	
	return self;
}

+(instancetype)deallocHookWithBlock:(RUDeallocHookBlock)deallocBlock
{
    return [[[self class]alloc]initWithBlock:deallocBlock];
}

#pragma mark - clearBlock
-(void)clearBlock
{
	kRUConditionalReturn(self.deallocBlock == nil, YES);

	_deallocBlock = nil;
}

@end
