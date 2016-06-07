//
//  NSPredicate+RUUtil.h
//  Shimmur
//
//  Created by Benjamin Maer on 12/10/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSPredicate (RUUtil)

+(instancetype)ru_predicateWithSearchText:(NSString*)searchText properties:(NSArray*)properties;

@end
