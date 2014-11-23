//
//  RUStatusBarBackgroundNavigationController+SMColoredNavigationBar.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUStatusBarBackgroundNavigationController.h"





@interface RUStatusBarBackgroundNavigationController (RUColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor statusBarColor:(UIColor*)statusBarColor;
-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor statusBarColor:(UIColor*)statusBarColor coloredNavigationBarClass:(Class)coloredNavigationBarClass;

-(instancetype)initWithColoredNavigationBarWithStatusAndNavigationBarColor:(UIColor*)statusAndNavigationBarColor;
-(instancetype)initWithColoredNavigationBarWithStatusAndNavigationBarColor:(UIColor*)statusAndNavigationBarColor coloredNavigationBarClass:(Class)coloredNavigationBarClass;

@end
