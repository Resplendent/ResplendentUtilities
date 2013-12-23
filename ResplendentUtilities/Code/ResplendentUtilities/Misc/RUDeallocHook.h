//
//  RUDeallocHook.h
//  Albumatic
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Albumatic Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RUDeallocHookBlock) (void);

@interface RUDeallocHook : NSObject
{
    RUDeallocHookBlock _deallocBlock;
}

-(id)initWithBlock:(RUDeallocHookBlock)deallocBlock;

+(instancetype)deallocHookWithBlock:(RUDeallocHookBlock)deallocBlock;

@end
