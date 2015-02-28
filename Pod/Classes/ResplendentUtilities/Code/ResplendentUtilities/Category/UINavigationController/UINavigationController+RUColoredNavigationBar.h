//
//  UINavigationController+RUColoredNavigationBar.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UINavigationController (RUColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor;
-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor coloredNavigationBarClass:(Class)coloredNavigationBarClass;

-(void)ru_setNavigationBarColor:(UIColor*)navigationBarColor;

@end
