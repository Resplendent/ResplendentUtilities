//
//  UIView+RUSuperviews.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 1/10/15.
//  Copyright (c) 2015 VibeWithIt. All rights reserved.
//

#import "UIView+RUSuperviews.h"





@implementation UIView (RUSuperviews)

-(UIView*)ru_viewOrSuperviewThatIsKindOfClass:(Class)viewClass
{
	if ([self isKindOfClass:viewClass])
	{
		return self;
	}
	else
	{
		return [self.superview ru_viewOrSuperviewThatIsKindOfClass:viewClass];
	}
}

@end
