//
//  UINavigationController+RUColoredNavigationBar.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UINavigationController+RUColoredNavigationBar.h"
#import "RUColoredNavigationBar.h"
#import "RUConditionalReturn.h"
#import "RUClassOrNilUtil.h"





@implementation UINavigationController (RUColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor
{
	return (self = [self initWithColoredNavigationBarWithColor:navigationBarColor coloredNavigationBarClass:[RUColoredNavigationBar class]]);
}

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor coloredNavigationBarClass:(Class)coloredNavigationBarClass
{
	if (coloredNavigationBarClass)
	{
		coloredNavigationBarClass = [RUColoredNavigationBar class];
	}

	kRUConditionalReturn_ReturnValueNil(kRUClassOrNil(coloredNavigationBarClass, RUColoredNavigationBar) == nil, YES);

	if (self = [self initWithNavigationBarClass:coloredNavigationBarClass toolbarClass:nil])
	{
		NSAssert(kRUClassOrNil(self.navigationBar, RUColoredNavigationBar), @"Must have a proper colored navbar");
		[kRUClassOrNil(self.navigationBar, RUColoredNavigationBar) setNavigationBarDrawColor:navigationBarColor];
	}
	
	return self;
}

@end
