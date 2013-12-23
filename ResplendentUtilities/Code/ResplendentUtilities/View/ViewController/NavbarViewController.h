//
//  NavbarViewController.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NavbarViewControllerTransitionFromStyleNone,
    NavbarViewControllerTransitionFromStyleFromRight,
    NavbarViewControllerTransitionFromStyleFromLeft,
    NavbarViewControllerTransitionFromStyleFromLeftQuarterDistance,
}NavbarViewControllerTransitionFromStyle;

typedef enum {
    NavbarViewControllerTransitionToStyleNone,
    NavbarViewControllerTransitionToStyleToRight,
    NavbarViewControllerTransitionToStyleToLeft,
    NavbarViewControllerTransitionToStyleToLeftQuarterDistance,
    NavbarViewControllerTransitionToStyleToBottom,
}NavbarViewControllerTransitionToStyle;

extern NSString* const kNavbarViewControllerNotificationCenterWillPop;
extern NSString* const kNavbarViewControllerNotificationCenterDidPop;
extern NSString* const kNavbarViewControllerNotificationCenterWillPush;
extern NSString* const kNavbarViewControllerNotificationCenterDidPush;

@class Navbar;

@interface NavbarViewController : UIViewController

@property (nonatomic, assign) BOOL ignoreNavbarSetFrameOnLayout;

@property (nonatomic, strong) Navbar* navbar;
@property (nonatomic, readonly) CGRect navbarFrame;
@property (nonatomic, readonly) CGRect contentFrame;

@property (nonatomic, assign) NavbarViewController* parentNBViewController;
@property (nonatomic, strong) NavbarViewController* childNBViewController;

@property (nonatomic, readonly) NavbarViewController* mostDistantChildNBViewController;

//User by parent on push, child on pop
@property (nonatomic, assign) NavbarViewControllerTransitionFromStyle pushChildTransitionStyle;
@property (nonatomic, assign) NavbarViewControllerTransitionToStyle pushTransitionStyle;
@property (nonatomic, assign) NavbarViewControllerTransitionFromStyle popParentTransitionStyle;
@property (nonatomic, assign) NavbarViewControllerTransitionToStyle popTransitionStyle;

@property (nonatomic, readonly) Class navbarClass;

//-(void)setTransitionStyleIncludeChildren:(NavbarViewControllerTransitionFromStyle)transitionStyle;
-(BOOL)isNavbarViewControllerAChild:(NavbarViewController*)navbarViewController;

-(void)setDefaultLeftToRightTransitionProperties;

-(void)popChildrenViewControllers:(BOOL)animated completion:(void (^)())completion;

-(void)pushViewController:(NavbarViewController*)navbarViewController animated:(BOOL)animated completion:(void (^)())completion;
-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;

-(void)navbarViewWillAppear:(BOOL)animated;
-(void)navbarViewDidAppear:(BOOL)animated;

-(void)navbarViewWillDisappear:(BOOL)animated;
-(void)navbarViewDidDisappear:(BOOL)animated;

-(void)navbarChildWillPerformPopAnimationToOrigin:(CGPoint)startParentOrigin;
-(void)navbarChildIsPerformingAnimationToOrigin:(CGPoint)animateToParentOrigin;

-(void)prepareForNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController withStartChildOrigin:(CGPoint)startChildOrigin;
-(void)performPushTransitionAnimationsWithChildOrigin:(CGPoint)animateToChildOrigin parentOrigin:(CGPoint)animateToParentOrigin;
-(void)performNavbarPushTransitionCompletionToViewController:(NavbarViewController*)navbarViewController;

-(void)performPopTransitionAnimationsWithChildOrigin:(CGPoint)animateToChildOrigin parentOrigin:(CGPoint)animateToParentOrigin;


+(void)setPushPopTransitionDuration:(NSTimeInterval)duration;

@end
