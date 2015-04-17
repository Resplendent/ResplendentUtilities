//
//  RUNavigationControllerDelegate_navbarColorSetter.h
//  Resplendent
//
//  Created by Benjamin Maer on 3/15/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface RUNavigationControllerDelegate_navbarColorSetter : NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) UIColor* defaultColor;

-(UIColor*)navbarColorForViewController:(UIViewController*)viewController;
-(UIColor*)statusBarColorForViewController:(UIViewController*)viewController;

-(void)updateNavigationController:(UINavigationController*)navigationController withColorFromViewController:(UIViewController*)viewController;

@end
