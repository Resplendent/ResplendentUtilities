//
//  RUDeallocHook.m
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUDeallocHook.h"
#import "RUDLog.h"





@implementation RUDeallocHook

-(id)initWithBlock:(RUDeallocHookBlock)deallocBlock
{
    if (!deallocBlock)
    {
        RUDLog(@"No reason to create dealloc hook if not using block");
    }

    if (self = [self init])
    {
        _deallocBlock = deallocBlock;
    }

    return self;
}

-(void)dealloc
{
    if (_deallocBlock)
    {
        _deallocBlock();
    }
}

+(instancetype)deallocHookWithBlock:(RUDeallocHookBlock)deallocBlock
{
    return [[[self class]alloc]initWithBlock:deallocBlock];
}

@end
