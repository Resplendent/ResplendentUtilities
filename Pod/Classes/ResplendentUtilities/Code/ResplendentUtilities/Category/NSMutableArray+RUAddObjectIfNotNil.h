//
//  NSMutableArray+RUAddObjectIfNotNil.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 10/14/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableArray<ObjectType> (RUAddObjectIfNotNil)

-(void)ru_addObjectIfNotNil:(ObjectType)object;

@end
