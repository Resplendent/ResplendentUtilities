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

@end



@implementation NavbarViewController

+(void)initialize
{
    if (self == [NavbarViewController class])
    {
        [self setPushPopTransitionDuration:kNavbarViewControllerPushPopAnimationDuration];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavbar:[self.navbarClass new]];
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

#pragma mark - Navbar class
-(Class)navbarClass
{
    @throw RU_MUST_OVERRIDE
}

#pragma mark - Public methods
//-(void)pushViewController:(NavbarViewController*)navbarViewController
//{
//    [self pushViewController:navbarViewController completion:nil];
//}

//-(void)popViewController
//{
//    [self popViewControllerCompletion:nil];
//}

-(void)popChildrenViewControllers:(BOOL)animated completion:(void (^)())completion
{
    [self.childNBViewController popViewControllerAnimated:animated completion:completion];
}

-(void)pushViewController:(NavbarViewController*)navbarViewController animated:(BOOL)animated completion:(void (^)())completion
{
    if (!navbarViewController)
    {
        if (completion)
            completion();
        return;
    }

    [navbarViewController setParentNBViewController:self];
    [self setChildNBViewController:navbarViewController];
    [self addChildViewController:navbarViewController];

    [self viewWillDisappear:animated];

    if (animated)
    {
        __block BOOL selfUserInteractionEnabled = self.view.userInteractionEnabled;
        __block BOOL childUserInteractionEnabled = navbarViewController.view.userInteractionEnabled;
        
        [self.view setUserInteractionEnabled:NO];
        [navbarViewController.view setUserInteractionEnabled:NO];

        switch (self.transitionStyle)
        {
            case NavbarViewControllerTransitionStyleFromLeft:
                setCoords(navbarViewController.view, -CGRectGetWidth(self.view.frame), 0);
                break;
                
            case NavbarViewControllerTransitionStyleFromRight:
            default:
                setCoords(navbarViewController.view, CGRectGetWidth(self.view.frame), 0);
                break;
        }
        [navbarViewController.navbar setAlphaForComponents:0.0f];
        
        [self.view addSubview:navbarViewController.view];
        [self.view bringSubviewToFront:self.navbar];

        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [self.navbar setAlphaForComponents:0.0f];
            
            [navbarViewController.navbar setAlphaForComponents:1.0f];
            
            setXCoord(navbarViewController.view, 0);
        } completion:^(BOOL finished) {
            [self.view setUserInteractionEnabled:selfUserInteractionEnabled];
            [navbarViewController.view setUserInteractionEnabled:childUserInteractionEnabled];
            
            [self.view bringSubviewToFront:navbarViewController.view];
            
            [self viewDidDisappear:YES];
            
            if (completion)
                completion();
        }];
    }
    else
    {
        [self.view addSubview:navbarViewController.view];
        setXCoord(navbarViewController.view, 0);
        [self viewDidDisappear:NO];
        if (completion)
            completion();
    }
}

-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
    [_parentNBViewController viewWillAppear:animated];

    if (animated)
    {
        [self.view setUserInteractionEnabled:NO];
        [_parentNBViewController.navbar setAlphaForComponents:0.0f];

        [self.navbar removeFromSuperview];
        [_parentNBViewController.view addSubview:self.navbar];
        
        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [self.navbar setAlphaForComponents:0.0f];
            
            [_parentNBViewController.navbar setAlphaForComponents:1.0f];
            
            switch (self.parentNBViewController.transitionStyle)
            {
                case NavbarViewControllerTransitionStyleFromLeft:
                    setXCoord(self.view, -CGRectGetWidth(_parentNBViewController.view.frame));
                    break;
                    
                case NavbarViewControllerTransitionStyleFromRight:
                default:
                    setXCoord(self.view, CGRectGetWidth(_parentNBViewController.view.frame));
                    break;
            }
            
        } completion:^(BOOL finished) {
            [self.navbar removeFromSuperview];
            [self.view addSubview:self.navbar];
            [self.view removeFromSuperview];

            [_parentNBViewController viewDidAppear:YES];
            [self removeFromParentViewController];
            [self setParentNBViewController:nil];
            [self setChildNBViewController:nil];
            
            if (completion)
                completion();
        }];
    }
    else
    {
        [self.view removeFromSuperview];
        [_parentNBViewController viewDidAppear:NO];
        [self removeFromParentViewController];
        [self setParentNBViewController:nil];
        [self setChildNBViewController:nil];
        if (completion)
            completion();
    }
}

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration
{
    popPushAnimationDuration = duration;
}

@end
