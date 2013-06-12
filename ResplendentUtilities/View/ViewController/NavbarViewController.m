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

#define kNavbarViewControllerPushPopNavbarMovementScale 8.0f

NSString* const kNavbarViewControllerNotificationCenterDidPop = @"kNavbarViewControllerNotificationCenterDidPop";
NSString* const kNavbarViewControllerNotificationCenterDidPush = @"kNavbarViewControllerNotificationCenterDidPush";

static NSTimeInterval popPushAnimationDuration;

@interface NavbarViewController ()

-(void)prepareForNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController;
-(void)performNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController;
-(void)performNavbarPushTransitionCompletionToViewController:(NavbarViewController*)navbarViewController;

-(void)prepareForNavbarPopTransition;
-(void)performNavbarPopTransition;
-(void)performNavbarPopTransitionCompletion;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bringNavbarToFont];
}

-(void)bringNavbarToFont
{
    if (_childNBViewController)
    {
        if (_childNBViewController.view.superview != self.view)
            RUDLog(@"child view's superview should be self's view");
        
        [self.navbar removeFromSuperview];
        [self.view insertSubview:self.navbar belowSubview:_childNBViewController.view];
    }
    else
    {
        [self.view bringSubviewToFront:self.navbar];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGRect)contentFrame
{
    return CGRectMake(0, CGRectGetMaxY(self.navbar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.navbar.frame));
}

#pragma mark - Navbar view lifecycle methods
-(void)navbarViewWillAppear:(BOOL)animated{}
-(void)navbarViewDidAppear:(BOOL)animated{}
-(void)navbarViewWillDisappear:(BOOL)animated{}
-(void)navbarViewDidDisappear:(BOOL)animated{}

#pragma mark - Navbar class
-(Class)navbarClass
{
    @throw RU_MUST_OVERRIDE
}

#pragma mark - Public methods
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

    if (_childNBViewController)
    {
        [_childNBViewController pushViewController:navbarViewController animated:animated completion:completion];
        return;
    }

    if (navbarViewController.view)
    {
        [navbarViewController.navbar layoutSubviews];
    }

    [navbarViewController setParentNBViewController:self];
    [self setChildNBViewController:navbarViewController];
    [self addChildViewController:navbarViewController];

    [self viewWillDisappear:animated];
    [navbarViewController navbarViewWillAppear:animated];

    if (animated)
    {
        __block NSMutableArray* userInteractionEnabledArray = [NSMutableArray array];

        //Loop through superviews and set then disabled, while storing their states
        UIView* superView = self.view.superview;
        while (superView)
        {
            [userInteractionEnabledArray addObject:@(superView.userInteractionEnabled)];
            [superView setUserInteractionEnabled:NO];
            superView = superView.superview;
        }

        __block BOOL selfUserInteractionEnabled = self.view.userInteractionEnabled;
        
        __block BOOL childUserInteractionEnabled = navbarViewController.view.userInteractionEnabled;

        [self.view setUserInteractionEnabled:NO];
        [navbarViewController.view setUserInteractionEnabled:NO];

        CGFloat originalParentXCoord = CGRectGetMinX(self.view.frame);
        CGFloat animateToChildXCoord = 0.0f;
        CGFloat animateToParentXCoord = originalParentXCoord;

        switch (self.pushChildTransitionStyle)
        {
            case NavbarViewControllerTransitionFromStyleFromLeft:
                [navbarViewController.view setFrame:CGRectSetXY(-CGRectGetWidth(self.view.frame), 0, navbarViewController.view.frame)];
                break;

            case NavbarViewControllerTransitionFromStyleFromRight:
                [navbarViewController.view setFrame:CGRectSetXY(CGRectGetWidth(self.view.frame), 0, navbarViewController.view.frame)];
                break;

            case NavbarViewControllerTransitionFromStyleNone:
                [navbarViewController.view setFrame:CGRectSetXY(0, 0, navbarViewController.view.frame)];
                break;
        }

        switch (self.pushTransitionStyle)
        {
            case NavbarViewControllerTransitionToStyleToLeft:
                animateToParentXCoord -= CGRectGetWidth(self.view.frame);
                animateToChildXCoord += CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToRight:
                animateToParentXCoord += CGRectGetWidth(self.view.frame);
                animateToChildXCoord -= CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleNone:
                break;
        }

        //Move navbar to superview
        [self.view addSubview:navbarViewController.view];

        [self prepareForNavbarPushTransitionToViewController:navbarViewController];

        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [self performPushTransitionAnimationsWithChildXCoord:animateToChildXCoord parentXCoord:animateToParentXCoord];
        } completion:^(BOOL finished) {
            //Move navbar back
            [self performNavbarPushTransitionCompletionToViewController:navbarViewController];

            [navbarViewController.view setFrame:CGRectSetX(0, navbarViewController.view.frame)];
            [self.view setFrame:CGRectSetX(originalParentXCoord, self.view.frame)];

            [self.view setUserInteractionEnabled:selfUserInteractionEnabled];
            [navbarViewController.view setUserInteractionEnabled:childUserInteractionEnabled];

            UIView* superView = self.view.superview;
            while (superView)
            {
                NSNumber* userInteractionEnabledNumber = [userInteractionEnabledArray objectAtIndex:0];
                [userInteractionEnabledArray removeObjectAtIndex:0];
                [superView setUserInteractionEnabled:userInteractionEnabledNumber.boolValue];
                superView = superView.superview;
            }

            [self.view bringSubviewToFront:navbarViewController.view];

            [self navbarViewDidDisappear:YES];
            [navbarViewController navbarViewDidAppear:YES];

            [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPush object:navbarViewController];
            if (completion)
                completion();
        }];
    }
    else
    {
        [self.view addSubview:navbarViewController.view];
        [navbarViewController.view setFrame:CGRectSetXY(0,0, navbarViewController.view.frame)];

        [self performNavbarPushTransitionCompletionToViewController:navbarViewController];

        [self navbarViewDidDisappear:NO];
        [navbarViewController navbarViewDidAppear:NO];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPush object:navbarViewController];
        if (completion)
            completion();
    }
}

-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (!_parentNBViewController)
        [NSException raise:NSInternalInconsistencyException format:@"can't pop with a nil parent navbar viewcontroller"];

    [_parentNBViewController navbarViewWillAppear:animated];
    [self navbarViewWillDisappear:animated];

    if (animated)
    {
        [self.view setUserInteractionEnabled:NO];

        CGFloat originalParentXCoord = CGRectGetMinX(_parentNBViewController.view.frame);
        CGFloat originalChildXCoord = CGRectGetMinX(self.view.frame);

        CGFloat startParentXCoord = originalParentXCoord;
        CGFloat startChildXCoord = originalChildXCoord;
        CGFloat animateToParentXCoord = originalParentXCoord;
        CGFloat animateToChildXCoord = originalChildXCoord;

        switch (self.popParentTransitionStyle)
        {
            case NavbarViewControllerTransitionFromStyleFromLeft:
                startParentXCoord -= CGRectGetWidth(_parentNBViewController.view.frame);
                startChildXCoord += CGRectGetWidth(_parentNBViewController.view.frame);
                break;
                
            case NavbarViewControllerTransitionFromStyleFromRight:
                startParentXCoord += CGRectGetWidth(_parentNBViewController.view.frame);
                startChildXCoord -= CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionFromStyleNone:
                break;
        }

        switch (self.popTransitionStyle)
        {
            case NavbarViewControllerTransitionToStyleToLeft:
                animateToChildXCoord -= CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToRight:
                animateToChildXCoord += CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleNone:
                break;
        }

        [self.view setFrame:CGRectSetX(startChildXCoord, self.view.frame)];

        [_parentNBViewController navbarChildWillPerformPopAnimationToXCoord:startParentXCoord];

        [self prepareForNavbarPopTransition];

        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [self performPopTransitionAnimationsWithChildXCoord:animateToChildXCoord parentXCoord:animateToParentXCoord];
        } completion:^(BOOL finished) {
            [self performNavbarPopTransitionCompletion];

            [_parentNBViewController navbarViewDidAppear:YES];
            [_parentNBViewController navbarViewDidDisappear:YES];
            
            [self postPopLogicCompletion:completion];
        }];
    }
    else
    {
        [_parentNBViewController navbarViewDidAppear:NO];
        [_parentNBViewController navbarViewDidDisappear:NO];
        [self postPopLogicCompletion:completion];
    }
}

-(void)postPopLogicCompletion:(void (^)())completion
{
    if (_childNBViewController)
    {
        [_childNBViewController popViewControllerAnimated:NO completion:^{
            [self postPopLogicCompletion:completion];
        }];
    }
    else
    {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        NavbarViewController* parent = self.parentNBViewController;
        NavbarViewController* child = self;
        [child setParentNBViewController:nil];
        [parent setChildNBViewController:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPop object:self];
        
        if (completion)
            completion();

    }
}

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration
{
    popPushAnimationDuration = duration;
}

#pragma mark - Transitions
-(void)performPushTransitionAnimationsWithChildXCoord:(CGFloat)animateToChildXCoord parentXCoord:(CGFloat)animateToParentXCoord
{
    [self.childNBViewController.view setFrame:CGRectSetX(animateToChildXCoord, self.childNBViewController.view.frame)];
    [self.view setFrame:CGRectSetX(animateToParentXCoord, self.view.frame)];

    [self performNavbarPushTransitionToViewController:self.childNBViewController];
}

-(void)navbarChildWillPerformPopAnimationToXCoord:(CGFloat)startParentXCoord
{
    [self.view setFrame:CGRectSetX(startParentXCoord, self.view.frame)];
}

-(void)navbarChildIsPerformingAnimationToXCoord:(CGFloat)animateToParentXCoord
{
    [self.view setFrame:CGRectSetX(animateToParentXCoord, self.view.frame)];
}

-(void)performPopTransitionAnimationsWithChildXCoord:(CGFloat)animateToChildXCoord parentXCoord:(CGFloat)animateToParentXCoord
{
    [self.view setFrame:CGRectSetX(animateToChildXCoord, self.view.frame)];
    [self.parentNBViewController navbarChildIsPerformingAnimationToXCoord:animateToParentXCoord];
    [self performNavbarPopTransition];
}

#pragma mark - Navbar Transitions
-(void)prepareForNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController
{
    [self.navbar removeFromSuperview];
    [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame), self.navbar.frame)];
    [navbarViewController.view insertSubview:self.navbar aboveSubview:navbarViewController.navbar];
    
    [navbarViewController.navbar.animatableContentView removeFromSuperview];
    [navbarViewController.navbar.animatableContentView setAlpha:0.0f];
    [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, navbarViewController.navbar.animatableContentView.frame)];
    [self.navbar addSubview:navbarViewController.navbar.animatableContentView];
}

-(void)performNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController
{
    [self.navbar.animatableContentView setAlpha:0.0f];
    [navbarViewController.navbar.animatableContentView setAlpha:1.0f];
    [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, self.navbar.frame)];
}

-(void)performNavbarPushTransitionCompletionToViewController:(NavbarViewController *)navbarViewController
{
    [self.navbar removeFromSuperview];
    [self.navbar setFrame:CGRectSetX(0,self.navbar.frame)];
    [self.view addSubview:self.navbar];
    
    [navbarViewController.navbar.animatableContentView removeFromSuperview];
    [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(0, navbarViewController.navbar.animatableContentView.frame)];
    [navbarViewController.navbar addSubview:navbarViewController.navbar.animatableContentView];
    
    [navbarViewController.navbar setAlpha:1.0f];
    [navbarViewController.navbar.animatableContentView setAlpha:1.0f];
    [self.navbar.animatableContentView setAlpha:1.0f];
}

-(void)prepareForNavbarPopTransition;
{
    [_parentNBViewController.navbar removeFromSuperview];
    [_parentNBViewController.navbar setFrame:CGRectSetX(0,_parentNBViewController.navbar.frame)];
    [self.view addSubview:_parentNBViewController.navbar];

    [self.navbar.superview bringSubviewToFront:self.navbar];

    [self.navbar.rightButton setAlpha:0.0f];

    [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, _parentNBViewController.navbar.animatableContentView.frame)];
}

-(void)performNavbarPopTransition;
{
    [self.navbar setAlpha:0.0f];
    [_parentNBViewController.navbar setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame),_parentNBViewController.navbar.frame)];
    [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(0, _parentNBViewController.navbar.animatableContentView.frame)];
    [self.navbar setFrame:CGRectSetX(CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, self.navbar.frame)];
}

-(void)performNavbarPopTransitionCompletion;
{
    [_parentNBViewController.navbar removeFromSuperview];
    [_parentNBViewController.navbar setFrame:CGRectSetX(0,_parentNBViewController.navbar.frame)];
    [_parentNBViewController.view addSubview:_parentNBViewController.navbar];
    
    [self.navbar removeFromSuperview];
    [self.view addSubview:self.navbar];
}

@end
