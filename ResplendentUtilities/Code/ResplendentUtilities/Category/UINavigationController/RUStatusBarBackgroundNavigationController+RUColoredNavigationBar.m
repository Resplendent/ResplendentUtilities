//
//  RUStatusBarBackgroundNavigationController+RUColoredNavigationBar.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUStatusBarBackgroundNavigationController+RUColoredNavigationBar.h"
#import "UINavigationController+RUColoredNavigationBar.h"





@implementation RUStatusBarBackgroundNavigationController (SMColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor statusBarColor:(UIColor*)statusBarColor
{
	if (self = [self initWithColoredNavigationBarWithColor:navigationBarColor])
	{
		[self setStatusBarBackgroundColor:statusBarColor];
	}
	
	return self;
}

-(instancetype)initWithColoredNavigationBarWithStatusAndNavigationBarColor:(UIColor*)statusAndNavigationBarColor
{
	return (self = [self initWithColoredNavigationBarWithColor:statusAndNavigationBarColor statusBarColor:statusAndNavigationBarColor]);
}

@end
