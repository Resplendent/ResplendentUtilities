//
//  RUSlideMenuNavigationController.h
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUSlideMenuNavigationControllerProtocols.h"





@interface RUSlideMenuNavigationController : UINavigationController

@property (nonatomic, assign) BOOL fitMenuViewsUnderStatusBar;

@property (nonatomic, assign) BOOL enableSwipeGesture;

@property (nonatomic, assign) CGFloat portraitSlideOffset;
@property (nonatomic, assign) CGFloat landscapeSlideOffset;

@property (nonatomic, strong) UIView* defaultRightMenuView;
@property (nonatomic, strong) UIView* defaultLeftMenuView;

@property (nonatomic, strong) id <RUSlideNavigationController_Animator> menuAnimator;

@property (nonatomic, assign) UIEdgeInsets menuViewFrameInsets;

- (void)bounceMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion;
- (void)openMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion;
- (void)closeMenuWithCompletion:(void (^)())completion;
- (void)toggleLeftMenu;
- (void)toggleRightMenu;
- (BOOL)isMenuOpen;

@end
