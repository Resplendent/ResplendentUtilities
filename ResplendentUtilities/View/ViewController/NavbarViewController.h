//
//  NavbarViewController.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NavbarViewControllerChildTransitionStyleNone,
    NavbarViewControllerChildTransitionStyleFromRight,
    NavbarViewControllerChildTransitionStyleFromLeft,
}NavbarViewControllerChildTransitionStyle;

typedef enum {
    NavbarViewControllerParentTransitionStyleNone,
    NavbarViewControllerParentTransitionStyleToRight,
    NavbarViewControllerParentTransitionStyleToLeft
}NavbarViewControllerParentTransitionStyle;

extern NSString* const kNavbarViewControllerNotificationCenterDidPop;
extern NSString* const kNavbarViewControllerNotificationCenterDidPush;

@class Navbar;

@interface NavbarViewController : UIViewController

@property (nonatomic, strong) Navbar* navbar;
@property (nonatomic, readonly) CGRect contentFrame;

@property (nonatomic, assign) NavbarViewController* parentNBViewController;
@property (nonatomic, strong) NavbarViewController* childNBViewController;

@property (nonatomic, assign) NavbarViewControllerChildTransitionStyle childTransitionStyle;
@property (nonatomic, assign) NavbarViewControllerParentTransitionStyle parentTransitionStyle;

@property (nonatomic, readonly) Class navbarClass;

//-(void)setTransitionStyleIncludeChildren:(NavbarViewControllerChildTransitionStyle)transitionStyle;

-(void)popChildrenViewControllers:(BOOL)animated completion:(void (^)())completion;

-(void)pushViewController:(NavbarViewController*)navbarViewController animated:(BOOL)animated completion:(void (^)())completion;
-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;

-(void)navbarViewWillAppear:(BOOL)animated;
-(void)navbarViewDidAppear:(BOOL)animated;

-(void)navbarViewWillDisappear:(BOOL)animated;
-(void)navbarViewDidDisappear:(BOOL)animated;

-(void)navbarChildWillPerformPopAnimationToXCoord:(CGFloat)startParentXCoord;
-(void)navbarChildIsPerformingAnimationToXCoord:(CGFloat)animateToParentXCoord;

-(void)performPushTransitionAnimationsWithChildXCoord:(CGFloat)animateToChildXCoord parentXCoord:(CGFloat)animateToParentXCoord;
-(void)performPopTransitionAnimationsWithChildXCoord:(CGFloat)animateToChildXCoord parentXCoord:(CGFloat)animateToParentXCoord;

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration;

@end
