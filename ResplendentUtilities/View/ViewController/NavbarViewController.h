//
//  NavbarViewController.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NavbarViewControllerTransitionStyleFromRight = 0,
    NavbarViewControllerTransitionStyleFromLeft,
    NavbarViewControllerTransitionStyleNone
}NavbarViewControllerTransitionStyle;

@class Navbar;

@interface NavbarViewController : UIViewController

@property (nonatomic, strong) Navbar* navbar;
@property (nonatomic, readonly) CGRect contentFrame;

@property (nonatomic, assign) NavbarViewController* parentNBViewController;
@property (nonatomic, assign) NavbarViewController* childNBViewController;
//@property (nonatomic, readonly) NavbarViewController* lastChildNBViewController;

@property (nonatomic, assign) NavbarViewControllerTransitionStyle transitionStyle;

@property (nonatomic, readonly) Class navbarClass;

-(void)setTransitionStyleIncludeChildren:(NavbarViewControllerTransitionStyle)transitionStyle;

-(void)popChildrenViewControllers:(BOOL)animated completion:(void (^)())completion;

-(void)pushViewController:(NavbarViewController*)navbarViewController animated:(BOOL)animated completion:(void (^)())completion;
-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration;

@end
