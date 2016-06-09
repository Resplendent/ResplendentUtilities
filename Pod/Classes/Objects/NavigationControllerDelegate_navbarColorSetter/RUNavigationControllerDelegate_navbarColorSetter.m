//
//  RUNavigationControllerDelegate_navbarColorSetter.m
//  Resplendent
//
//  Created by Benjamin Maer on 3/15/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import "RUNavigationControllerDelegate_navbarColorSetter.h"
#import "UINavigationController+RUColoredNavigationBar.h"
#import "UINavigationController+RUColoredStatusBarView.h"
#import "RUProtocolOrNil.h"
#import "RUNavigationControllerDelegate_navbarColorSetterProtocols.h"
#import "UIViewController+RUNavigationBarColorSetterDelegate.h"
#import "RUConditionalReturn.h"





@implementation RUNavigationControllerDelegate_navbarColorSetter

-(void)updateNavigationController:(UINavigationController*)navigationController withColorFromViewController:(UIViewController*)viewController
{
	UIColor* color_navigationBarColor = [self navbarColorForViewController:viewController];
	[navigationController ru_setNavigationBarColor:color_navigationBarColor];

	UIColor* color_statusBar = [self statusBarColorForViewController:viewController];
	[navigationController setRu_statusBarBackgroundColor:color_statusBar];
}

#pragma mark - Colors
-(UIColor*)navbarColorForViewController:(UIViewController*)viewController
{
	kRUConditionalReturn_ReturnValue(viewController == nil, YES, self.defaultColor);

	id<RUViewController_NavigationBarColorSetterDelegate> ru_viewController_NavigationBarColorSetterDelegate = viewController.ru_viewController_NavigationBarColorSetterDelegate;
	if (ru_viewController_NavigationBarColorSetterDelegate)
	{
		UIColor* color = [ru_viewController_NavigationBarColorSetterDelegate ruViewController_NavigationBarColorSetterDelegate_colorForViewController:viewController];
		if ((color != nil) ||
			(self.useDefaultColorWhenOtherSourcesReturnNil == false))
		{
			return color;
		}
	}
	
	id<RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate> viewControllerColorDelegate = kRUProtocolOrNil(viewController, RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate);
	if (viewControllerColorDelegate)
	{
		UIColor* color = [viewControllerColorDelegate ruNavigationControllerDelegate_navbarColorSetter_colorForNavigationBar:self];
		if ((color != nil) ||
			(self.useDefaultColorWhenOtherSourcesReturnNil == false))
		{
			return color;
		}
	}

	return self.defaultColor;
}

-(UIColor*)statusBarColorForViewController:(UIViewController*)viewController
{
	kRUConditionalReturn_ReturnValue(viewController == nil, YES, [self navbarColorForViewController:viewController]);

	id<RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate> viewControllerColorDelegate = kRUProtocolOrNil(viewController, RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate);
	if (viewControllerColorDelegate &&
		[viewController respondsToSelector:@selector(ruNavigationControllerDelegate_navbarColorSetter_colorForStatusBar:)])
	{
		return [viewControllerColorDelegate ruNavigationControllerDelegate_navbarColorSetter_colorForStatusBar:self];
	}

	return [self navbarColorForViewController:viewController];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self updateNavigationController:navigationController withColorFromViewController:viewController];
}

@end
