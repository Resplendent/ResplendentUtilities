//
//  ScrollToTopManager.h
//  Albumatic
//
//  Created by Benjamin Maer on 1/14/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUSingleton.h"

@interface ScrollToTopManager : NSObject

+(void)popOffStack;
+(void)addToStack:(UIScrollView*)scrollView;
+(NSUInteger)indexInStack:(UIScrollView*)scrollView;

@end
