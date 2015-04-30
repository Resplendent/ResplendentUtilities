//
//  UIViewController+RUNavigationBarColorSetterDelegate.m
//  Resplendent
//
//  Created by Benjamin Maer on 3/20/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import "UIViewController+RUNavigationBarColorSetterDelegate.h"
#import "RUSynthesizeAssociatedObjects.h"





NSString* const kUIViewController_RUNavigationBarColorSetterDelegate_AssociatedObject_Key_navbarColorSetter = @"kUIViewController_RUNavigationBarColorSetterDelegate_AssociatedObject_Key_navbarColorSetter";





@implementation UIViewController (RUNavigationBarColorSetterDelegate)

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru_, Ru_, viewController_NavigationBarColorSetterDelegate, id<RUViewController_NavigationBarColorSetterDelegate>, &kUIViewController_RUNavigationBarColorSetterDelegate_AssociatedObject_Key_navbarColorSetter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
