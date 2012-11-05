//
//  NavbarViewController.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Navbar;

@interface NavbarViewController : UIViewController

@property (nonatomic, strong) Navbar* navbar;
@property (nonatomic, readonly) CGRect contentFrame;

@property (nonatomic, retain) NavbarViewController* parentNBViewController;

-(void)loadNavBar;

-(void)pushViewController:(NavbarViewController*)navbarViewController;
-(void)popViewController;

-(void)pushViewController:(NavbarViewController*)navbarViewController completion:(void (^)())completion;
-(void)popViewControllerCompletion:(void (^)())completion;

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration;

@end
