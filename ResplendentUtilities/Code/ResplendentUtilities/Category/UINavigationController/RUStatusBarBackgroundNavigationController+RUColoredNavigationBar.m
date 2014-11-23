//
//  RUStatusBarBackgroundNavigationController+RUColoredNavigationBar.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUStatusBarBackgroundNavigationController+RUColoredNavigationBar.h"
#import "UINavigationController+RUColoredNavigationBar.h"





@implementation RUStatusBarBackgroundNavigationController (RUColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor statusBarColor:(UIColor*)statusBarColor
{
	return (self = [self initWithColoredNavigationBarWithColor:navigationBarColor statusBarColor:statusBarColor coloredNavigationBarClass:nil]);
}

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor statusBarColor:(UIColor*)statusBarColor coloredNavigationBarClass:(__unsafe_unretained Class)coloredNavigationBarClass
{
	if (self = [self initWithColoredNavigationBarWithColor:navigationBarColor coloredNavigationBarClass:coloredNavigationBarClass])
	{
		[self setStatusBarBackgroundColor:statusBarColor];
	}
	
	return self;
}

-(instancetype)initWithColoredNavigationBarWithStatusAndNavigationBarColor:(UIColor*)statusAndNavigationBarColor
{
	return (self = [self initWithColoredNavigationBarWithStatusAndNavigationBarColor:statusAndNavigationBarColor coloredNavigationBarClass:nil]);
}

-(instancetype)initWithColoredNavigationBarWithStatusAndNavigationBarColor:(UIColor*)statusAndNavigationBarColor coloredNavigationBarClass:(__unsafe_unretained Class)coloredNavigationBarClass
{
	return (self = [self initWithColoredNavigationBarWithColor:statusAndNavigationBarColor statusBarColor:statusAndNavigationBarColor coloredNavigationBarClass:coloredNavigationBarClass]);
}

@end
