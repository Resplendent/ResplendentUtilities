//
//  UIViewController+RUNavigationBarColorSetterDelegate.h
//  Resplendent
//
//  Created by Benjamin Maer on 3/20/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUViewController_NavigationBarColorSetterProtocols.h"





@interface UIViewController (RUNavigationBarColorSetterDelegate)

@property (nonatomic, assign) id<RUViewController_NavigationBarColorSetterDelegate> ru_viewController_NavigationBarColorSetterDelegate;

@end
