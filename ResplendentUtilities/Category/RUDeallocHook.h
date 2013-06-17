//
//  RUDeallocHook.h
//  Pineapple
//
//  Created by Benjamin Maer on 6/16/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RUDeallocHookBlock)();

@interface RUDeallocHook : NSObject

@property (nonatomic, assign) RUDeallocHookBlock deallocHook;

@end
