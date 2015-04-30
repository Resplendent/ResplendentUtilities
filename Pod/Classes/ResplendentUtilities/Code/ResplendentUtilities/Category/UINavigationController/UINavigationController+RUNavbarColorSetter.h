//
//  UINavigationController+RUNavbarColorSetter.h
//  Nifti
//
//  Created by Benjamin Maer on 3/15/15.
//  Copyright (c) 2015 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@class RUNavigationControllerDelegate_navbarColorSetter;





@interface UINavigationController (RUNavbarColorSetter)

@property (nonatomic, strong) RUNavigationControllerDelegate_navbarColorSetter* ru_navbarColorSetter;

-(void)ru_setupNavbarColorSetterWithDefaultColor:(UIColor*)defaultColor;
-(void)ru_setupNavbarColorSetterWithDefaultColor:(UIColor*)defaultColor navbarColorSetterClass:(Class)navbarColorSetterClass;
-(void)ru_updateNavbarColors;

@end
