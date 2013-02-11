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

    if (animated)
    {
        __block NSMutableArray* userInteractionEnabledArray = [NSMutableArray array];
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

        switch (self.childTransitionStyle)
        {
            case NavbarViewControllerChildTransitionStyleFromLeft:
                setCoords(navbarViewController.view, -CGRectGetWidth(self.view.frame), 0);
                break;
                
            case NavbarViewControllerChildTransitionStyleFromRight:
                setCoords(navbarViewController.view, CGRectGetWidth(self.view.frame), 0);
                break;

            case NavbarViewControllerChildTransitionStyleNone:
                setCoords(navbarViewController.view, 0, 0);
                break;
        }

        switch (self.parentTransitionStyle)
        {
            case NavbarViewControllerParentTransitionStyleToLeft:
                animateToParentXCoord -= CGRectGetWidth(self.view.frame);
                animateToChildXCoord += CGRectGetWidth(self.view.frame);
                break;

            default:
                RU_METHOD_IMPLEMENTATION_NEEDED;
                break;
        }

        [navbarViewController.navbar.rightButton setAlpha:0.0f];

        //Move navbar to superview
        [self.view addSubview:navbarViewController.view];

        [self.navbar removeFromSuperview];
        [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame), self.navbar.frame)];
        [navbarViewController.view insertSubview:self.navbar aboveSubview:navbarViewController.navbar];

        [navbarViewController.navbar.animatableContentView removeFromSuperview];
        [navbarViewController.navbar.animatableContentView setAlpha:0.0f];
        [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, navbarViewController.navbar.animatableContentView.frame)];
        [self.navbar addSubview:navbarViewController.navbar.animatableContentView];

        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [navbarViewController.view setFrame:CGRectSetX(animateToChildXCoord, navbarViewController.view.frame)];
            [self.view setFrame:CGRectSetX(animateToParentXCoord, self.view.frame)];

            [self.navbar.animatableContentView setAlpha:0.0f];
            [navbarViewController.navbar.animatableContentView setAlpha:1.0f];

            [self.navbar setFrame:CGRectSetX(-CGRectGetWidth(self.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, self.navbar.frame)];
        } completion:^(BOOL finished) {
            //Move navbar back
            [self.navbar removeFromSuperview];
            [self.navbar setFrame:CGRectSetXY(0, 0, self.navbar.frame)];
            [self.view addSubview:self.navbar];

            [navbarViewController.navbar.animatableContentView removeFromSuperview];
            [navbarViewController.navbar.animatableContentView setFrame:CGRectSetX(0, navbarViewController.navbar.animatableContentView.frame)];
            [navbarViewController.navbar addSubview:navbarViewController.navbar.animatableContentView];

            [navbarViewController.navbar setAlpha:1.0f];
            [navbarViewController.navbar.animatableContentView setAlpha:1.0f];
            [self.navbar.animatableContentView setAlpha:1.0f];

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

            [self viewDidDisappear:YES];

            [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPush object:navbarViewController];
            if (completion)
                completion();
        }];
    }
    else
    {
        [self.view addSubview:navbarViewController.view];
        [navbarViewController.view setFrame:CGRectSetXY(0, 0, navbarViewController.view.frame)];
//        setXCoord(navbarViewController.view, 0);
        [self viewDidDisappear:NO];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPush object:navbarViewController];
        if (completion)
            completion();
    }
}

-(void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
    if (!_parentNBViewController)
        [NSException raise:NSInternalInconsistencyException format:@"can't pop with a nil parent navbar viewcontroller"];

    [_parentNBViewController viewWillAppear:animated];

    if (animated)
    {
        [self.view setUserInteractionEnabled:NO];

        CGFloat originalParentXCoord = CGRectGetMinX(_parentNBViewController.view.frame);
        CGFloat originalChildXCoord = CGRectGetMinX(self.view.frame);

        CGFloat startParentXCoord = originalParentXCoord;
        CGFloat startChildXCoord = originalChildXCoord;
        CGFloat animateToParentXCoord = originalParentXCoord;
        CGFloat animateToChildXCoord = originalChildXCoord;

        switch (self.parentNBViewController.childTransitionStyle)
        {
            case NavbarViewControllerChildTransitionStyleFromLeft:
                animateToChildXCoord -= CGRectGetWidth(_parentNBViewController.view.frame);
                break;
                
            case NavbarViewControllerChildTransitionStyleFromRight:
                animateToChildXCoord += CGRectGetWidth(_parentNBViewController.view.frame);
                break;

            case NavbarViewControllerChildTransitionStyleNone:
                break;
        }

        switch (self.parentNBViewController.parentTransitionStyle)
        {
            case NavbarViewControllerParentTransitionStyleToLeft:
                startParentXCoord -= CGRectGetWidth(_parentNBViewController.view.frame);
                startChildXCoord += CGRectGetWidth(_parentNBViewController.view.frame);
                break;
                
            default:
                break;
        }

        [self.view setFrame:CGRectSetX(startChildXCoord, self.view.frame)];
        [_parentNBViewController.view setFrame:CGRectSetX(startParentXCoord, _parentNBViewController.view.frame)];

        [_parentNBViewController.navbar removeFromSuperview];
        [_parentNBViewController.navbar setFrame:CGRectSetX(0,_parentNBViewController.navbar.frame)];
        [self.view addSubview:_parentNBViewController.navbar];

        [self.navbar removeFromSuperview];
        [_parentNBViewController.navbar addSubview:self.navbar];

        [self.navbar.rightButton setAlpha:0.0f];

        [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, _parentNBViewController.navbar.animatableContentView.frame)];

        [UIView animateWithDuration:popPushAnimationDuration animations:^{
            [self.navbar setAlpha:0.0f];

            [self.view setFrame:CGRectSetX(animateToChildXCoord, self.view.frame)];
            [_parentNBViewController.view setFrame:CGRectSetX(animateToParentXCoord, _parentNBViewController.view.frame)];

            [_parentNBViewController.navbar setFrame:CGRectSetX(-CGRectGetWidth(_parentNBViewController.view.frame),_parentNBViewController.navbar.frame)];
            [_parentNBViewController.navbar.animatableContentView setFrame:CGRectSetX(0, _parentNBViewController.navbar.animatableContentView.frame)];
            [self.navbar setFrame:CGRectSetX(CGRectGetWidth(_parentNBViewController.view.frame) / kNavbarViewControllerPushPopNavbarMovementScale, self.navbar.frame)];
        } completion:^(BOOL finished) {
            [_parentNBViewController.navbar removeFromSuperview];
            [_parentNBViewController.navbar setFrame:CGRectSetX(0,_parentNBViewController.navbar.frame)];
            [_parentNBViewController.view addSubview:_parentNBViewController.navbar];

            [self.navbar removeFromSuperview];
            [self.view addSubview:self.navbar];

            [_parentNBViewController viewDidAppear:YES];
            [self postPopLogicCompletion:completion];
        }];
    }
    else
    {
        [_parentNBViewController viewDidAppear:NO];
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
        [self setParentNBViewController:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNavbarViewControllerNotificationCenterDidPop object:self];
        
        if (completion)
            completion();

        [parent setChildNBViewController:nil];
    }
}

+(void)setPushPopTransitionDuration:(NSTimeInterval)duration
{
    popPushAnimationDuration = duration;
}

@end
