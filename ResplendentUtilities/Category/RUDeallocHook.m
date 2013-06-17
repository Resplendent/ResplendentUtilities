//
//  RUDeallocHook.m
//  Pineapple
//
//  Created by Benjamin Maer on 6/16/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUDeallocHook.h"

@implementation RUDeallocHook

-(void)dealloc
{
    if (self.deallocHook)
    {
        self.deallocHook();
    }
}

@end
