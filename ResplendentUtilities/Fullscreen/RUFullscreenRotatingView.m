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

@interface RUFullscreenRotatingView ()

@property (nonatomic, readonly) CGRect contentViewFrame;

@property (nonatomic, readonly) CGRect shadowViewFrame;

//++++ Orientation
@property (nonatomic, assign) BOOL orientationNotificationsEnabled;
@property (nonatomic, readonly) CGAffineTransform contentViewTransformationForCurrentOrientation;

-(void)transitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
-(CGAffineTransform)contentViewTransformationForOrientation:(UIInterfaceOrientation)orientation;
//----

-(void)performSharedHideAnimationBlock;
-(void)performSharedHideCompletionBlock;

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
-(BOOL)readyToShow
{
    return (self.state == RUFullscreenRotatingViewStateHiding && !self.orientationNotificationsEnabled);
}

-(BOOL)readyToHide
{
    return (self.state == RUFullscreenRotatingViewStateShowing && self.orientationNotificationsEnabled);
}

#pragma mark - Visibility Transitions
-(void)showWithCompletion:(void (^)())completion
{
    if (self.readyToShow)
    {
        _state = RUFullscreenRotatingViewStateMovingToShow;

        [self updateFrame];
//        [self setNeedsLayout];

        [_shadowView setAlpha:0.0f];
        [self.presenterView addSubview:self];

        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.25f animations:^{
            [_shadowView setAlpha:1.0f];
            [self transitionToOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation animated:NO];
        } completion:^(BOOL finished) {
            _state = RUFullscreenRotatingViewStateShowing;
            [self setOrientationNotificationsEnabled:YES];
            if (completion)
                completion();
        }];
    }
}

-(void)hide
{
    [self hideAnimated:YES completion:nil];
}

-(void)performSharedHideAnimationBlock
{
    [_shadowView setAlpha:0.0f];
    [self transitionToOrientation:UIInterfaceOrientationPortrait animated:NO];
}

-(void)performSharedHideCompletionBlock
{
    _state = RUFullscreenRotatingViewStateHiding;
    [self removeFromSuperview];
}

-(void)hideAnimated:(BOOL)animated completion:(void(^)(BOOL didHide))completion
{
    if (self.readyToHide)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self setOrientationNotificationsEnabled:NO];

        if (animated)
        {
            _state = RUFullscreenRotatingViewStateMovingToHide;
            [_shadowView setAlpha:1.0f];
            [UIView animateWithDuration:0.25f animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [self performSharedHideAnimationBlock];
            } completion:^(BOOL finished) {
                [self performSharedHideCompletionBlock];
                if (completion)
                    completion(YES);
            }];
        }
        else
        {
            [self performSharedHideAnimationBlock];
            [self performSharedHideCompletionBlock];
            if (completion)
                completion(YES);
        }
    }
    else
    {
        if (completion)
            completion(NO);
    }
}


#pragma mark - Orientation methods
-(void)transitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.25f animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [self transitionToOrientation:orientation animated:NO];
        }];
    }
    else
    {
        CGAffineTransform newTransform = [self contentViewTransformationForOrientation:orientation];
        if (!CGAffineTransformEqualToTransform(_contentView.transform, newTransform))
        {
            [_contentView setTransform:newTransform];
        }
    }
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
