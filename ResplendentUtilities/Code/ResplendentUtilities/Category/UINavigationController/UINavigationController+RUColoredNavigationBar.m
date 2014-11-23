//
//  UINavigationController+RUColoredNavigationBar.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UINavigationController+RUColoredNavigationBar.h"
#import "RUColoredNavigationBar.h"





@implementation UINavigationController (RUColoredNavigationBar)

-(instancetype)initWithColoredNavigationBarWithColor:(UIColor*)navigationBarColor
{
	if (self = [self initWithNavigationBarClass:[RUColoredNavigationBar class] toolbarClass:nil])
	{
		[kRUClassOrNil(self.navigationBar, RUColoredNavigationBar) setNavigationBarDrawColor:navigationBarColor];
	}
	
	return self;
}

@end
