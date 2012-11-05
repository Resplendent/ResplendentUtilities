//
//  NavbarViewController.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "NavbarViewController.h"
#import "Navbar.h"
#import "RUConstants.h"
#import "UIView+Utility.h"

#define kNavbarViewControllerPushPopAnimationDuration 0.3f

static NSTimeInterval popPushAnimationDuration;

@interface NavbarViewController ()

-(void)pushViewController:(NavbarViewController*)navbarViewController completion:(void (^)())completion;
-(void)popViewControllerCompletion:(void (^)())completion;

@end



@implementation NavbarViewController

@synthesize navbar;
@synthesize parentNBViewController = _parentNBViewController;

+(void)initialize
{
    if (self == [NavbarViewController class])
    {
        [self setPushPopTransitionDuration:kNavbarViewControllerPushPopAnimationDuration];
    }
}

-(void)loadNavBar
{
    RU_MUST_OVERRIDE
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadNavBar];
//    [self.view rounderCorners:0 withRadius:0];
    [self.view addSubview:self.navbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    [self.navbar removeFromSuperview];
    [self setNavbar:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navbar];
    [self.view.superview bringSubviewToFront:self.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGRect)contentFrame
{
    return CGRectMake(0, CGRectGetMaxY(self.navbar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.navbar.frame));
}

#pragma mark - Public methods
-(void)pushViewController:(NavbarViewController*)navbarViewController
{
    [self pushViewController:navbarViewController completion:nil];
}

-(void)popViewController
{
    [self popViewControllerCompletion:nil];
}

#pragma mark - Private methods

-(void)pushViewController:(NavbarViewController*)navbarViewController completion:(void (^)())completion
{
    [navbarViewController setParentNBViewController:self];
    [self addChildViewController:navbarViewController];

    setCoords(navbarViewController.view, CGRectGetWidth(self.view.frame), 0);
    [navbarViewController.navbar setAlphaForComponents:0.0f];

    [self.view addSubview:navbarViewController.view];
    [self.view bringSubviewToFront:self.navbar];

    [self viewWillDisappear:YES];
    [UIView animateWithDuration:popPushAnimationDuration animations:^{
        [self.navbar setAlphaForComponents:0.0f];

        [navbarViewController.navbar setAlphaForComponents:1.0f];

        setXCoord(navbarViewController.view, 0);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:navbarViewController.view];
        
        [self viewDidDisappear:YES];

        if (completion)
            completion();
    }];
}

-(void)popViewControllerCompletion:(void (^)())completion
{
    [_parentNBViewController viewWillAppear:YES];
    [_parentNBViewController.navbar setAlphaForComponents:0.0f];
    
    [self.navbar removeFromSuperview];
    [_parentNBViewController.view addSubview:self.navbar];

    [UIView animateWithDuration:popPushAnimationDuration animations:^{
        [self.navbar setAlphaForComponents:0.0f];

        [_parentNBViewController.navbar setAlphaForComponents:1.0f];

        setXCoord(self.view, CGRectGetWidth(_parentNBViewController.view.frame));
    } completion:^(BOOL finished) {
        [self.navbar removeFromSuperview];
        [self.view addSubview:self.navbar];
        [self.view removeFromSuperview];

        [_parentNBViewController viewDidAppear:YES];
        [self removeFromParentViewController];
        [self setParentNBViewController:nil];

        if (completion)
            completion();
    }];
}

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration
{
    popPushAnimationDuration = duration;
}

@end
