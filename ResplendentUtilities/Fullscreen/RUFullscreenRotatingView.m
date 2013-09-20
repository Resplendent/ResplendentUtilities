//
//  RUFullscreenRotatingView.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFullscreenRotatingView.h"

#import "UIView+Utility.h"
#import "RUConstants.h"

CGFloat const kRUFullscreenRotatingViewDefaultShowAnimationDuration = 0.25;
CGFloat const kRUFullscreenRotatingViewDefaultHideAnimationDuration = 0.25;
CGFloat const kRUFullscreenRotatingViewDefaultRotationAnimationDuration = 0.25;

@interface RUFullscreenRotatingView ()

@property (nonatomic, readonly) CGRect contentViewFrame;

@property (nonatomic, readonly) CGRect shadowViewFrame;

//++++ Orientation
@property (nonatomic, assign) BOOL orientationNotificationsEnabled;
@property (nonatomic, readonly) CGAffineTransform contentViewTransformationForCurrentOrientation;

-(void)transitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
-(void)transitionToOrientation:(UIInterfaceOrientation)orientation;
-(CGAffineTransform)contentViewTransformationForOrientation:(UIInterfaceOrientation)orientation;
//----

-(void)notificationDidFireForOrientationDidChange:(NSNotification*)notification;

-(void)didTapContentView:(UITapGestureRecognizer*)tap;

@end

@implementation RUFullscreenRotatingView

-(id)init
{
    return ([self initWithFrame:[UIScreen mainScreen].bounds]);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setShowAnimationDuration:kRUFullscreenRotatingViewDefaultShowAnimationDuration];
        [self setHideAnimationDuration:kRUFullscreenRotatingViewDefaultHideAnimationDuration];
        [self setRotationAnimationDuration:kRUFullscreenRotatingViewDefaultRotationAnimationDuration];

        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapContentView:)]];
        [self addSubview:_contentView];

        _shadowView = [UIView new];
        [_shadowView setBackgroundColor:[UIColor blackColor]];
        [_shadowView setClipsToBounds:NO];
        [_shadowView setUserInteractionEnabled:NO];
        [_contentView addSubview:_shadowView];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_contentView setFrame:self.contentViewFrame];
    [_shadowView setFrame:self.shadowViewFrame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    if (newSuperview && self.presenterView != newSuperview)
    {
        [NSException raise:NSInternalInconsistencyException format:@"%@ can only be a subview of its presenter %@, not %@",self,self.presenterView,newSuperview];
    }
}

#pragma mark - Frames
-(CGRect)contentViewFrame
{
    return self.bounds;
}

-(CGRect)adjustedContentViewFrame
{
    return CGRectApplyAffineTransform(self.bounds, self.contentViewTransformationForCurrentOrientation);
}

-(CGRect)shadowViewFrame
{
    CGRect adjustedContentViewFrame = self.adjustedContentViewFrame;
    return (CGRect){-CGRectGetWidth(adjustedContentViewFrame),-CGRectGetHeight(adjustedContentViewFrame),CGRectGetWidth(adjustedContentViewFrame) * 3.0f,CGRectGetHeight(adjustedContentViewFrame) * 3.0f};
}

#pragma mark - Update Content
-(void)updateFrame
{
    CGFloat statusBarHeight = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    [self setFrame:CGRectSetY(-statusBarHeight, [UIScreen mainScreen].bounds)];
}

#pragma mark - Actions
-(void)didTapContentView:(UITapGestureRecognizer*)tap
{
    [self hide];
}

#pragma mark - Getters
-(BOOL)preparedToShow
{
    return self.readyToShow;
}

-(BOOL)readyToShow
{
    return (self.state == RUFullscreenRotatingViewStateHiding && !self.orientationNotificationsEnabled);
}

-(BOOL)readyToHide
{
    return (self.state == RUFullscreenRotatingViewStateShowing && self.orientationNotificationsEnabled);
}

#pragma mark - Visibility Transitions
-(void)showWithCompletion:(void (^)(BOOL didShow))completion
{
    if (self.readyToShow && self.preparedToShow)
    {
        [self willPerformShowAnimation];

        _state = RUFullscreenRotatingViewStateMovingToShow;

        [UIView animateWithDuration:self.showAnimationDuration animations:^{
            [self performShowAnimation];
        } completion:^(BOOL finished) {
            _state = RUFullscreenRotatingViewStateShowing;
            [self setOrientationNotificationsEnabled:YES];
            [self didShow];
            if (completion)
                completion(YES);
        }];
    }
    else
    {
        if (completion)
            completion(NO);
    }
}

-(void)willPerformShowAnimation
{
    [self updateFrame];
    
    [_shadowView setAlpha:0.0f];
    [self.presenterView addSubview:self];

    [self layoutIfNeeded];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)performShowAnimation
{
    if (self.state != RUFullscreenRotatingViewStateMovingToShow)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Shouldn't be called directly"];
    }

    [_shadowView setAlpha:1.0f];
    [self transitionToOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation animated:NO];
}

-(void)didShow
{
    
}

-(void)hide
{
    [self hideAnimated:YES completion:nil];
}

-(void)hideAnimated:(BOOL)animated completion:(void(^)(BOOL didHide))completion
{
    void (^hideAnimation)() = ^{
        [_shadowView setAlpha:0.0f];
        [self transitionToOrientation:UIInterfaceOrientationPortrait animated:NO];
        [self performHideAnimation];
    };

    void (^finishHide)() = ^{
        [self removeFromSuperview];
        _state = RUFullscreenRotatingViewStateHiding;

        [self didHide];
        
        if (completion)
            completion(YES);
    };

    if (self.readyToHide)
    {
        [self setOrientationNotificationsEnabled:NO];

        [self.hideDelegate fullscreenRotatingView:self willHide:animated];

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

        if (animated)
        {
            _state = RUFullscreenRotatingViewStateMovingToHide;
            [self willPerformHideAnimation];
            [UIView animateWithDuration:self.hideAnimationDuration animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                hideAnimation();
            } completion:^(BOOL finished) {
                finishHide();
            }];
        }
        else
        {
            hideAnimation();
            finishHide();
        }
    }
    else
    {
        if (completion)
            completion(NO);
    }
}

-(void)willPerformHideAnimation
{
    [_shadowView setAlpha:1.0f];
}

-(void)performHideAnimation
{

}

-(void)didHide
{

}

#pragma mark - Orientation methods
-(void)transitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated
{
    [self willTransitionToOrientation:orientation animated:animated];

    if (animated)
    {
        [UIView animateWithDuration:self.rotationAnimationDuration animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [self transitionToOrientation:orientation];
        }];
    }
    else
    {
        [self transitionToOrientation:orientation];
    }
}

-(void)willTransitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated
{
    
}

-(void)transitionToOrientation:(UIInterfaceOrientation)orientation
{
    BOOL didUpdateOrientation = NO;
    CGAffineTransform newTransform = [self contentViewTransformationForOrientation:orientation];
    if (CGAffineTransformEqualToTransform(_contentView.transform, newTransform))
    {
        if (self.forceLayoutSubviewsOnTransition)
        {
            [self layoutSubviews];
        }
    }
    else
    {
        didUpdateOrientation = YES;
        [_contentView setTransform:newTransform];
    }

    [self transitionToOrientation:orientation didUpdateOrientation:didUpdateOrientation];
}

-(void)transitionToOrientation:(UIInterfaceOrientation)orientation didUpdateOrientation:(BOOL)didUpdateOrientation
{
    
}

-(void)setOrientationNotificationsEnabled:(BOOL)orientationNotificationsEnabled
{
    if (self.orientationNotificationsEnabled == orientationNotificationsEnabled)
        return;

    _orientationNotificationsEnabled = orientationNotificationsEnabled;

    if (self.orientationNotificationsEnabled)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidFireForOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
}

-(CGAffineTransform)contentViewTransformationForCurrentOrientation
{
    return [self contentViewTransformationForOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
}

-(CGAffineTransform)contentViewTransformationForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat radians = 0;
    
    switch (orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            radians = -M_PI_2;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            radians = M_PI_2;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            radians = M_PI;
            break;
            
        default:
            break;
    }
    
    return CGAffineTransformMakeRotation(radians);
}

-(void)notificationDidFireForOrientationDidChange:(NSNotification*)notification
{
    [self transitionToOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation animated:YES];
}

@end
