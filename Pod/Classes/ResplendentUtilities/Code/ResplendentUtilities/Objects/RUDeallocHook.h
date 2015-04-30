//
//  RUDeallocHook.h
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>





typedef void (^RUDeallocHookBlock) (void);





@interface RUDeallocHook : NSObject

-(id)initWithBlock:(RUDeallocHookBlock)deallocBlock;
-(void)clearBlock;

+(instancetype)deallocHookWithBlock:(RUDeallocHookBlock)deallocBlock;

@end
