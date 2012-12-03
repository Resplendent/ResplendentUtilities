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
    NavbarViewControllerTransitionStyleFromLeft
}NavbarViewControllerTransitionStyle;

@class Navbar;

@interface NavbarViewController : UIViewController

@property (nonatomic, strong) Navbar* navbar;
@property (nonatomic, readonly) CGRect contentFrame;

@property (nonatomic, assign) NavbarViewController* parentNBViewController;

@property (nonatomic, assign) NavbarViewControllerTransitionStyle transitionStyle;

-(void)loadNavBar;

-(void)pushViewController:(NavbarViewController*)navbarViewController;
-(void)popViewController;

-(void)pushViewController:(NavbarViewController*)navbarViewController completion:(void (^)())completion;
-(void)popViewControllerCompletion:(void (^)())completion;

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration;

@end
