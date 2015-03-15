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





@implementation RUNavigationControllerDelegate_navbarColorSetter

-(void)updateNavigationController:(UINavigationController*)navigationController withColorFromViewController:(UIViewController*)viewController
{
	UIColor* color = [self navbarColorForViewController:viewController];
	
	[navigationController ru_setNavigationBarColor:color];
	[navigationController setRu_statusBarBackgroundColor:color];
}

-(UIColor*)navbarColorForViewController:(UIViewController*)viewController
{
	id<RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate> viewControllerColorDelegate = kRUProtocolOrNil(viewController, RUNavigationControllerDelegate_navbarColorSetter_viewControllerColorDelegate);

	return (viewControllerColorDelegate == nil ? self.defaultColor :
			[viewControllerColorDelegate ruNavigationControllerDelegate_navbarColorSetter_colorForNavigationBar:self]);
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self updateNavigationController:navigationController withColorFromViewController:viewController];
}

@end
