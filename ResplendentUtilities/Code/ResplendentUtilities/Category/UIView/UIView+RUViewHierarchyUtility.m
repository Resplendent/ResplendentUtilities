//
//  UIView+RUViewHierarchyUtility.m
//  Resplendent
//
//  Created by Benjamin Maer on 5/26/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIView+RUViewHierarchyUtility.h"

#import "RUClassOrNilUtil.h"





@implementation UIView (RUViewHierarchyUtility)

-(BOOL)ruIsDescendantOfViewWithClass:(Class)viewClass
{
	if (kRUClassOrNil(self, UITableViewCell))
	{
		return YES;
	}
	else
	{
		return [self.superview ruIsDescendantOfViewWithClass:viewClass];
	}
}

@end
