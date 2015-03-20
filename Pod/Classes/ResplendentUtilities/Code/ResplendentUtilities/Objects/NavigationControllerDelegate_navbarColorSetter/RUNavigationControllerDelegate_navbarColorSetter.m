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





@implementation RUNavigationControllerDelegate_navbarColorSetter

-(void)updateNavigationController:(UINavigationController*)navigationController withColorFromViewController:(UIViewController*)viewController
{
	UIColor* color = [self navbarColorForViewController:viewController];
	
	[navigationController ru_setNavigationBarColor:color];
	[navigationController setRu_statusBarBackgroundColor:color];
}

-(UIColor*)navbarColorForViewController:(UIViewController*)viewController
{
	kRUConditionalReturn_ReturnValue(viewController == nil, YES, self.defaultColor);

	id<RUViewController_NavigationBarColorSetterDelegate> ru_viewController_NavigationBarColorSetterDelegate = viewController.ru_viewController_NavigationBarColorSetterDelegate;
	if (ru_viewController_NavigationBarColorSetterDelegate)
	{
		return [ru_viewController_NavigationBarColorSetterDelegate ruViewController_NavigationBarColorSetterDelegate_colorForViewController:viewController];
	}
	
	id<RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate> viewControllerColorDelegate = kRUProtocolOrNil(viewController, RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate);
	if (viewControllerColorDelegate)
	{
		return [viewControllerColorDelegate ruNavigationControllerDelegate_navbarColorSetter_colorForNavigationBar:self];
	}

	return self.defaultColor;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self updateNavigationController:navigationController withColorFromViewController:viewController];
}

@end
