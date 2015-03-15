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





NSString* const kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter = @"kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter";





@implementation UINavigationController (RUNavbarColorSetter)

-(void)ru_setupNavbarColorSetterWithDefaultColor:(UIColor*)defaultColor
{
	if (self.ru_navbarColorSetter == nil)
	{
		[self setRu_navbarColorSetter:[RUNavigationControllerDelegate_navbarColorSetter new]];
		[self setDelegate:self.ru_navbarColorSetter];
	}
	
	[self.ru_navbarColorSetter setDefaultColor:defaultColor];
}

-(void)ru_updateNavbarColors
{
	NSAssert(self.ru_navbarColorSetter != nil, @"unhandled");
	NSAssert(self.delegate == self.ru_navbarColorSetter, @"unhandled");
	
	[self.ru_navbarColorSetter updateNavigationController:self withColorFromViewController:self.visibleViewController];
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, navbarColorSetter, RUNavigationControllerDelegate_navbarColorSetter*, &kUINavigationController_RUNavbarColorSetter_AssociatedObject_Key_navbarColorSetter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
