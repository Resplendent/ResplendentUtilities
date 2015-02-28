//
//  UIViewController+RUTabBarVisibility.m
//  Shimmur
//
//  Created by Benjamin Maer on 1/13/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "UITabBarController+RUTabBarVisibility.h"
#import "RUConditionalReturn.h"





@implementation UITabBarController (RUTabBarVisibility)

-(void)ru_setTabBarVisibility:(BOOL)tabBarVisibility animated:(BOOL)animated animation:(void(^)(CGRect newTabBarFrame,CGFloat tableContentInsetBottomDelta))animation
{
	CGRect tabBarFrame = self.tabBar.frame;
	
	CGFloat tabBarFrameYCoord = CGRectGetMaxY(self.view.frame);
	if (tabBarVisibility)
	{
		tabBarFrameYCoord -= CGRectGetHeight(tabBarFrame);
	}
	
	tabBarFrame.origin.y = tabBarFrameYCoord;
	
	kRUConditionalReturn(CGRectEqualToRect(self.tabBar.frame, tabBarFrame), NO);

	CGFloat tableContentInsetBottomDelta = CGRectGetHeight(tabBarFrame);
	
	if (tabBarVisibility == false)
	{
		tableContentInsetBottomDelta *= -1.0f;
	}
	
	[UIView animateWithDuration:0.25f animations:^{
		
		[self.tabBar setFrame:tabBarFrame];

		if (animation)
		{
			animation(tabBarFrame,tableContentInsetBottomDelta);
		}
		
	}];
}

@end
