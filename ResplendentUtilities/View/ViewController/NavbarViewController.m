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
#import <CoreFoundation/CFBase.h>

NSTimeInterval const kNavbarViewControllerPushPopAnimationDefaultDuration = 0.25f;
NSTimeInterval const kNavbarViewControllerPushPopAnimationDefaultModalMultiplier = 1.5f;

NSTimeInterval const  kNavbarViewControllerPushPopNavbarMovementScale = 8.0f;

NSString* const kNavbarViewControllerNotificationCenterWillPop = @"kNavbarViewControllerNotificationCenterWillPop";
NSString* const kNavbarViewControllerNotificationCenterDidPop = @"kNavbarViewControllerNotificationCenterDidPop";
NSString* const kNavbarViewControllerNotificationCenterWillPush = @"kNavbarViewControllerNotificationCenterWillPush";
NSString* const kNavbarViewControllerNotificationCenterDidPush = @"kNavbarViewControllerNotificationCenterDidPush";

static NSTimeInterval popPushAnimationDuration;

@interface NavbarViewController ()

-(void)bringNavbarToFont;

-(void)performNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController;

-(void)prepareForNavbarPopTransition;
-(void)performNavbarPopTransition;
-(void)performNavbarPopTransitionCompletion;

@end



@implementation NavbarViewController

+(void)initialize
{
    if (self == [NavbarViewController class])
    {
        [self setPushPopTransitionDuration:kNavbarViewControllerPushPopAnimationDefaultDuration];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    Class navbarClass = self.navbarClass;
    if (navbarClass)
    {
        [self setNavbar:[self.navbarClass new]];
        [self.view addSubview:self.navbar];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bringNavbarToFont];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.navbar && !self.ignoreNavbarSetFrameOnLayout)
    {
        [self.navbar setFrame:self.navbarFrame];
    }
}

#pragma mark - Frames
-(CGRect)navbarFrame
{
    return (CGRect){0,0,[self.navbar sizeThatFits:self.view.bounds.size]};
}

-(CGRect)contentFrame
{
    CGFloat yCoord = 0;

    if (self.navbar)
    {
        yCoord = CGRectGetMaxY(self.navbar.frame);
    }

    return CGRectMake(0, yCoord, self.view.frame.size.width, self.view.frame.size.height - yCoord);
}

#pragma mark - Update Content
-(void)bringNavbarToFont
{
    if (self.navbar)
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
}

#pragma mark - Getters
-(NavbarViewController *)mostDistantChildNBViewController
{
    if (self.childNBViewController)
    {
        return self.childNBViewController.mostDistantChildNBViewController;
    }
    else
    {
        return self;
    }
}

-(BOOL)isNavbarViewControllerAChild:(NavbarViewController*)navbarViewController
{
    if (self.childNBViewController)
    {
        if (self.childNBViewController == navbarViewController)
        {
            return YES;
        }
        else
        {
            return [self.childNBViewController isNavbarViewControllerAChild:navbarViewController];
        }
    }
    else
    {
        return NO;
    }
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
-(void)setDefaultLeftToRightTransitionProperties
{
    if (RUiOSSystemVersionIsAtLeast(7.0))
    {
        [self setPushTransitionStyle:NavbarViewControllerTransitionToStyleToLeftQuarterDistance];
        [self setPopParentTransitionStyle:NavbarViewControllerTransitionFromStyleFromLeftQuarterDistance];
    }
    else
    {
        [self setPushTransitionStyle:NavbarViewControllerTransitionToStyleToLeft];
        [self setPopParentTransitionStyle:NavbarViewControllerTransitionFromStyleFromLeft];
    }

    [self setPushChildTransitionStyle:NavbarViewControllerTransitionFromStyleFromRight];
    
    [self setPopTransitionStyle:NavbarViewControllerTransitionToStyleToRight];
}

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

    CGPoint animateToChildOrigin = CGPointZero;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterWillPush object:navbarViewController];

    if (animated)
    {
        [self setIgnoreNavbarSetFrameOnLayout:YES];
        [navbarViewController setIgnoreNavbarSetFrameOnLayout:YES];
        __block NSMutableArray* userInteractionEnabledArray = [NSMutableArray array];

        //Loop through superviews and set then disabled, while storing their states
        UIView* superView = self.view.superview;
        while (superView)
        {
            [userInteractionEnabledArray addObject:@(superView.userInteractionEnabled)];
            [superView setUserInteractionEnabled:NO];
            superView = superView.superview;
        }

        BOOL oldClipToBounds = self.view.clipsToBounds;
        [self.view setClipsToBounds:NO];

        __block BOOL selfUserInteractionEnabled = self.view.userInteractionEnabled;
        
        __block BOOL childUserInteractionEnabled = navbarViewController.view.userInteractionEnabled;

        [self.view setUserInteractionEnabled:NO];
        [navbarViewController.view setUserInteractionEnabled:NO];

        CGPoint originalParentOrigin = self.view.frame.origin;
        CGPoint startChildOrigin = CGPointZero;
        CGPoint animateToParentOrigin = originalParentOrigin;

        CGFloat animationDuration = popPushAnimationDuration;

        switch (self.pushChildTransitionStyle)
        {
            case NavbarViewControllerTransitionFromStyleFromLeft:
                startChildOrigin.x = -CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionFromStyleFromLeftQuarterDistance:
                startChildOrigin.x = -CGRectGetWidth(self.view.frame) * 0.25f;
                break;

            case NavbarViewControllerTransitionFromStyleFromRight:
                startChildOrigin.x = CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionFromStyleNone:
                break;
        }

        switch (self.pushTransitionStyle)
        {
            case NavbarViewControllerTransitionToStyleToLeft:
                animateToParentOrigin.x -= CGRectGetWidth(self.view.frame);
                animateToChildOrigin.x += CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToRight:
                animateToParentOrigin.x += CGRectGetWidth(self.view.frame);
                animateToChildOrigin.x -= CGRectGetWidth(self.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToBottom:
                animationDuration *= kNavbarViewControllerPushPopAnimationDefaultModalMultiplier;
                animateToParentOrigin.y += CGRectGetHeight(self.view.window.frame);
                animateToChildOrigin.y -= CGRectGetHeight(self.view.window.frame);
                break;

            case NavbarViewControllerTransitionToStyleToLeftQuarterDistance:
                animateToParentOrigin.x -= CGRectGetWidth(self.view.frame) * 0.25f;
                animateToChildOrigin.x += CGRectGetWidth(self.view.frame) * 0.25f;
                break;

            case NavbarViewControllerTransitionToStyleNone:
                break;
        }

        //Move navbar to superview
        [self.view addSubview:navbarViewController.view];

        [self prepareForNavbarPushTransitionToViewController:navbarViewController withStartChildOrigin:startChildOrigin];

        [UIView animateWithDuration:animationDuration animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self performPushTransitionAnimationsWithChildOrigin:animateToChildOrigin parentOrigin:animateToParentOrigin];
        } completion:^(BOOL finished) {
            [self setIgnoreNavbarSetFrameOnLayout:NO];
            [navbarViewController setIgnoreNavbarSetFrameOnLayout:NO];

            [self.view setClipsToBounds:oldClipToBounds];

            //Move navbar back
            [self performNavbarPushTransitionCompletionToViewController:navbarViewController];

            [navbarViewController.view setFrame:CGRectSetX(0, navbarViewController.view.frame)];
            [self.view setFrame:(CGRect){originalParentOrigin,self.view.frame.size}];

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
        [navbarViewController.view setFrame:(CGRect){animateToChildOrigin, navbarViewController.view.frame.size}];

//        [self performNavbarPushTransitionCompletionToViewController:navbarViewController];

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
    {
        [NSException raise:NSInternalInconsistencyException format:@"can't pop with a nil parent navbar viewcontroller"];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterWillPop object:self];

    [_parentNBViewController navbarViewWillAppear:animated];
    [self navbarViewWillDisappear:animated];

    if (animated)
    {
        [self setIgnoreNavbarSetFrameOnLayout:YES];
        [_parentNBViewController setIgnoreNavbarSetFrameOnLayout:YES];

        BOOL oldClipToBounds = self.parentNBViewController.view.clipsToBounds;
        [self.parentNBViewController.view setClipsToBounds:NO];

        [self.view setUserInteractionEnabled:NO];

        CGPoint originalParentOrigin = _parentNBViewController.view.frame.origin;
        CGPoint originalChildOrigin = self.view.frame.origin;

        CGPoint startParentOrigin = originalParentOrigin;
        CGPoint startChildOrigin = originalChildOrigin;
        CGPoint animateToParentOrigin = originalParentOrigin;
        CGPoint animateToChildOrigin = originalChildOrigin;

        NSTimeInterval animationDuration = popPushAnimationDuration;

        switch (self.popParentTransitionStyle)
        {
            case NavbarViewControllerTransitionFromStyleFromLeft:
                startParentOrigin.x -= CGRectGetWidth(_parentNBViewController.view.frame);
                startChildOrigin.x += CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionFromStyleFromLeftQuarterDistance:
                startParentOrigin.x -= CGRectGetWidth(_parentNBViewController.view.frame) * 0.25f;
                startChildOrigin.x += CGRectGetWidth(_parentNBViewController.view.frame) * 0.25f;
                break;
                
            case NavbarViewControllerTransitionFromStyleFromRight:
                startParentOrigin.x += CGRectGetWidth(_parentNBViewController.view.frame);
                startChildOrigin.x -= CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionFromStyleNone:
                break;
        }

        switch (self.popTransitionStyle)
        {
            case NavbarViewControllerTransitionToStyleToLeft:
            case NavbarViewControllerTransitionToStyleToLeftQuarterDistance:
                animateToChildOrigin.x -= CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToRight:
                animateToChildOrigin.x += CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerTransitionToStyleToBottom:
                animationDuration *= kNavbarViewControllerPushPopAnimationDefaultModalMultiplier;
                animateToChildOrigin.y += CGRectGetHeight(_parentNBViewController.view.window.frame);
                break;

            case NavbarViewControllerTransitionToStyleNone:
                break;
        }

        [self.view setFrame:(CGRect){startChildOrigin, self.view.frame.size}];

        [_parentNBViewController navbarChildWillPerformPopAnimationToOrigin:startParentOrigin];

        [self prepareForNavbarPopTransition];

        [UIView animateWithDuration:animationDuration animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self performPopTransitionAnimationsWithChildOrigin:animateToChildOrigin parentOrigin:animateToParentOrigin];
        } completion:^(BOOL finished) {
            [self.parentNBViewController.view setClipsToBounds:oldClipToBounds];

            [self setIgnoreNavbarSetFrameOnLayout:NO];
            [_parentNBViewController setIgnoreNavbarSetFrameOnLayout:NO];

            [self performNavbarPopTransitionCompletion];

            [_parentNBViewController navbarViewDidAppear:YES];
            [self navbarViewDidDisappear:YES];

            [self postPopLogicCompletion:completion];
        }];
    }
    else
    {
        [_parentNBViewController navbarViewDidAppear:NO];
        [self navbarViewDidDisappear:NO];
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
-(void)performPushTransitionAnimationsWithChildOrigin:(CGPoint)animateToChildOrigin parentOrigin:(CGPoint)animateToParentOrigin
{
    [self.childNBViewController.view setFrame:(CGRect){animateToChildOrigin,self.childNBViewController.view.frame.size}];
//     CGRectSetX(animateToChildXCoord, self.childNBViewController.view.frame)];
    [self.view setFrame:(CGRect){animateToParentOrigin,self.view.frame.size}];
//     CGRectSetX(animateToParentXCoord, self.view.frame)];

    [self performNavbarPushTransitionToViewController:self.childNBViewController];
}

-(void)navbarChildWillPerformPopAnimationToOrigin:(CGPoint)startParentOrigin
{
    [self.view setFrame:(CGRect){startParentOrigin, self.view.frame.size}];
}

-(void)navbarChildIsPerformingAnimationToOrigin:(CGPoint)animateToParentOrigin
{
    [self.view setFrame:(CGRect){animateToParentOrigin, self.view.frame.size}];
}

-(void)performPopTransitionAnimationsWithChildOrigin:(CGPoint)animateToChildOrigin parentOrigin:(CGPoint)animateToParentOrigin
{
    [self.view setFrame:(CGRect){animateToChildOrigin, self.view.frame.size}];
    [self.parentNBViewController navbarChildIsPerformingAnimationToOrigin:animateToParentOrigin];
    [self performNavbarPopTransition];
}

#pragma mark - Navbar Transitions
-(void)moveNavbarToParentForPushTransitionPreperation
{
    [self.navbar removeFromSuperview];
//    [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame), self.navbar.frame)];
    [self.childNBViewController.view insertSubview:self.navbar aboveSubview:self.childNBViewController.navbar];

    [self.childNBViewController.navbar.animatableContentView removeFromSuperview];
//    [self.childNBViewController.navbar.animatableContentView setAlpha:0.0f];
//    [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, navbarViewController.navbar.animatableContentView.frame)];

    [self.navbar addSubview:self.childNBViewController.navbar.animatableContentView];
//    [self.childNBViewController.navbar removeFromSuperview];
//    [self.childNBViewController.childNBViewController.view insertSubview:self.childNBViewController.navbar aboveSubview:self.childNBViewController.childNBViewController.navbar];

//    [self.navbar addSubview:self.childNBViewController.navbar.animatableContentView];
}

-(void)recursivelyAddChildNavbarsToNavbarForPush
{
    if (self.childNBViewController.childNBViewController)
    {
        [self.childNBViewController moveNavbarToParentForPushTransitionPreperation];
        [self.childNBViewController recursivelyAddChildNavbarsToNavbarForPush];
    }
}

-(void)prepareForNavbarPushTransitionToViewController:(NavbarViewController*)navbarViewController withStartChildOrigin:(CGPoint)startChildOrigin
{
    [navbarViewController.view setFrame:(CGRect){startChildOrigin, navbarViewController.view.frame.size}];
//    [self recursivelyAddChildNavbarsToNavbarForPush];

    [self moveNavbarToParentForPushTransitionPreperation];
//    [self.navbar removeFromSuperview];
    [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame), self.navbar.frame)];
//    [navbarViewController.view insertSubview:self.navbar aboveSubview:navbarViewController.navbar];

//    [navbarViewController.navbar.animatableContentView removeFromSuperview];
    [navbarViewController.navbar.animatableContentView setAlpha:0.0f];
    [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, navbarViewController.navbar.animatableContentView.frame)];

//    [self.navbar addSubview:navbarViewController.navbar.animatableContentView];
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

-(void)prepareForNavbarPopTransition
{
    switch (self.popTransitionStyle)
    {
        case NavbarViewControllerTransitionToStyleToLeft:
        case NavbarViewControllerTransitionToStyleToRight:
        case NavbarViewControllerTransitionToStyleToLeftQuarterDistance:
            [_parentNBViewController.navbar removeFromSuperview];
            [_parentNBViewController.navbar setFrame:CGRectSetX(0,_parentNBViewController.navbar.frame)];
            [self.view addSubview:_parentNBViewController.navbar];
            
            [self.navbar.superview bringSubviewToFront:self.navbar];
            
            [self.navbar.rightButton setAlpha:0.0f];
            
            [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, _parentNBViewController.navbar.animatableContentView.frame)];
            break;

        case NavbarViewControllerTransitionToStyleToBottom:
            break;

        case NavbarViewControllerTransitionToStyleNone:
            break;
    }
}

-(void)performNavbarPopTransition
{
    switch (self.popTransitionStyle)
    {
        case NavbarViewControllerTransitionToStyleToLeft:
        case NavbarViewControllerTransitionToStyleToRight:
        case NavbarViewControllerTransitionToStyleToLeftQuarterDistance:
            [self.navbar setAlpha:0.0f];
            [_parentNBViewController.navbar setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame),_parentNBViewController.navbar.frame)];
            [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(0, _parentNBViewController.navbar.animatableContentView.frame)];
            [self.navbar setFrame:CGRectSetX(CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, self.navbar.frame)];
            break;

        case NavbarViewControllerTransitionToStyleToBottom:
            break;

        case NavbarViewControllerTransitionToStyleNone:
            break;
    }
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
