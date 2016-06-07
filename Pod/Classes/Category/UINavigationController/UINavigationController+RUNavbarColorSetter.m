//
//  UINavigationController+RUNavbarColorSetter.m
//  Nifti
//
//  Created by Benjamin Maer on 3/15/15.
//  Copyright (c) 2015 Nifti. All rights reserved.
//

#import "UINavigationController+RUNavbarColorSetter.h"
#import "RUNavigationControllerDelegate_navbarColorSetter.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "RUConditionalReturn.h"





NSString* const kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter = @"kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter";





@implementation UINavigationController (RUNavbarColorSetter)

-(void)ru_setupNavbarColorSetterWithDefaultColor:(UIColor*)defaultColor
{
	return [self ru_setupNavbarColorSetterWithDefaultColor:defaultColor navbarColorSetterClass:[RUNavigationControllerDelegate_navbarColorSetter class]];
}

-(void)ru_setupNavbarColorSetterWithDefaultColor:(UIColor*)defaultColor navbarColorSetterClass:(Class)navbarColorSetterClass
{
	kRUConditionalReturn(kRUClassOrNil(navbarColorSetterClass, RUNavigationControllerDelegate_navbarColorSetter) == nil, YES);

	if (self.ru_navbarColorSetter == nil)
	{
		[self setRu_navbarColorSetter:[navbarColorSetterClass new]];
		[self setDelegate:self.ru_navbarColorSetter];
	}
	
	[self.ru_navbarColorSetter setDefaultColor:defaultColor];
}

-(void)ru_updateNavbarColors
{
	NSAssert(self.ru_navbarColorSetter != nil, @"unhandled");
	NSAssert(self.delegate == self.ru_navbarColorSetter, @"unhandled");

	UIViewController* topViewController = self.topViewController;
	kRUConditionalReturn(self != topViewController.navigationController, YES);
	
	[self.ru_navbarColorSetter updateNavigationController:self withColorFromViewController:topViewController];
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, navbarColorSetter, RUNavigationControllerDelegate_navbarColorSetter*, &kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
