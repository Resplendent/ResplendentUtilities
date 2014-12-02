//
//  RUSlideMenuNavigationControllerProtocols.h
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <Foundation/Foundation.h>





typedef NS_ENUM(NSInteger, RUSlideNavigationController_MenuType) {
	RUSlideNavigationController_MenuType_Left,
	RUSlideNavigationController_MenuType_Right
};





@protocol RUSlideNavigationController_Animator <NSObject>

// Initial state of the view before animation starts
// This gets called right before the menu is about to reveal
- (void)prepareMenuForAnimation:(RUSlideNavigationController_MenuType)menu;

// Animate the view based on the progress (progress is between 0 and 1)
- (void)animateMenu:(RUSlideNavigationController_MenuType)menu withProgress:(CGFloat)progress;

// Gets called ff for any the instance of animator is being change
// You should make any cleanup that is needed
- (void)clear;

@end





@protocol RUSlideNavigationController_DisplayDelegate <NSObject>

@optional
- (BOOL)ru_slideNavigationController_shouldDisplayMenuType:(RUSlideNavigationController_MenuType)menuType;
- (UIView*)ru_slideNavigationController_viewForMenuType:(RUSlideNavigationController_MenuType)menuType;

@end
