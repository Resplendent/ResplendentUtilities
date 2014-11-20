//
//  PAModalView.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUModalView.h"
#import "UIView+RUCancelControlTracking.h"
#import "UIView+RUUtility.h"
#import "RUConditionalReturn.h"





@interface RUModalView ()

@property (nonatomic, readonly) UIView* shadowView;
@property (nonatomic, readonly) CGRect shadowViewFrame;

@property (nonatomic, assign) BOOL isTransitioning;

@end





@implementation RUModalView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		[self setTransitionAnimationType:RUModalView_TransitionAnimation_Type_Default];

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelf:)];
		[self.tapGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:_tapGestureRecognizer];

		_shadowView = [UIView new];
		[self.shadowView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7f]];
		[self addSubview:self.shadowView];

		_contentView = [UIView new];
		[self.contentView setBackgroundColor:[UIColor whiteColor]];
		[self.contentView.layer setCornerRadius:5.0f];
		[self.contentView setClipsToBounds:YES];
		[self addSubview:self.contentView];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.superview bringSubviewToFront:self];

	[self.shadowView setFrame:self.shadowViewFrame];
	[self.shadowView.superview sendSubviewToBack:self.shadowView];

	if (_contentView)
	{
		[self.contentView setFrame:self.contentViewFrame];
	}
}

#pragma mark - Action methods
-(void)didTapSelf:(UITapGestureRecognizer*)tap
{
	kRUConditionalReturn(self.isTransitioning, NO);

	[self dismiss:YES completion:nil];
}

#pragma mark - Public Display Content methods
-(void)showInView:(UIView*)presenterView completion:(void(^)())completion
{
    if (presenterView == nil)
	{
		NSAssert(FALSE, @"Must pass a non nil presenterView");
		return;
	}

	if (self.isTransitioning)
	{
		NSAssert(FALSE, @"already transitioning");
		return;
	}

	[self setIsTransitioning:YES];

	[presenterView ruEndAllControlTrackingWithTouch:nil event:nil];
	[presenterView ruCancelAllControlTrackingWithEvent:nil];

    [presenterView addSubview:self];
    [self setFrame:presenterView.bounds];
    [self layoutSubviews];

	[self.contentView setFrame:self.contentViewFrameForNonRestingState];
	[self willShowContentView];

    [UIView animateWithDuration:0.25f animations:^{

		[self.contentView setFrame:self.contentViewFrame];
		[self isShowingContentView];

    } completion:^(BOOL finished) {

		[self setIsTransitioning:NO];

        if (completion)
            completion();

    }];
}

-(void)dismiss:(BOOL)animate completion:(void(^)())completion
{
	if (self.isTransitioning)
	{
		NSAssert(FALSE, @"already transitioning");
		return;
	}

    if (animate)
    {
		[self setIsTransitioning:YES];

        [UIView animateWithDuration:0.25f animations:^{

			[self.contentView setFrame:self.contentViewFrameForNonRestingState];
			[self isDismissingContentView];

        } completion:^(BOOL finished) {

			[self setIsTransitioning:NO];

            [self removeFromSuperview];

            if (completion)
                completion();

        }];
    }
    else
    {
        [self removeFromSuperview];

        if (completion)
            completion();
    }
}

#pragma mark - Frames
-(CGRect)shadowViewFrame
{
	return self.bounds;
}

-(CGRect)contentViewFrame
{
    return (CGRect){
		.origin.x = 0,
		.origin.y = self.contentViewYCoord,
		.size.width = CGRectGetWidth(self.bounds),
		.size.height = self.contentViewHeight
    };
}

-(CGFloat)contentViewYCoord
{
    return 0;
}

-(CGFloat)contentViewHeight
{
    return CGRectGetHeight(self.bounds);
}

-(CGRect)innerContentViewFrame
{
    CGFloat yCoord = 0;
    
    CGRect contentViewFrame = self.contentViewFrame;
    CGFloat height = CGRectGetHeight(contentViewFrame) - yCoord;
	
    return (CGRect){0,yCoord,CGRectGetWidth(contentViewFrame),height};
}

-(CGRect)contentViewFrameForNonRestingState
{
	switch (self.transitionAnimationType)
	{
		case RUModalView_TransitionAnimation_Type_Bottom:
			return CGRectSetY(CGRectGetHeight(self.bounds), self.contentViewFrame);

		case RUModalView_TransitionAnimation_Type_Top:
		{
			CGRect contentViewFrame = self.contentViewFrame;
			return (CGRect){
				.origin.x = 0,
				.origin.y = -CGRectGetHeight(contentViewFrame),
				.size = contentViewFrame.size
			};
		}

		default:
			return self.contentViewFrame;
			break;
	}
}

#pragma mark - Animation
-(void)willShowContentView
{
	[self.shadowView setAlpha:0.0f];

	switch (self.transitionAnimationType)
	{
		case RUModalView_TransitionAnimation_Type_Fade:
			[self.contentView setAlpha:0.0f];
			break;
			
		default:
			break;
	}
}

-(void)isShowingContentView
{
	[self.shadowView setAlpha:1.0f];

	switch (self.transitionAnimationType)
	{
		case RUModalView_TransitionAnimation_Type_Fade:
			[self.contentView setAlpha:1.0f];
			break;

		default:
			break;
	}
}

-(void)isDismissingContentView
{
	[self.shadowView setAlpha:0.0f];

	switch (self.transitionAnimationType)
	{
		case RUModalView_TransitionAnimation_Type_Fade:
			[self.contentView setAlpha:0.0f];
			break;

		default:
			break;
	}
}

#pragma mark - disableShadow
-(BOOL)disableShadow
{
	return self.shadowView.isHidden;
}

-(void)setDisableShadow:(BOOL)disableShadow
{
	kRUConditionalReturn(self.disableShadow == disableShadow, NO);

	[self.shadowView setHidden:disableShadow];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return [self shouldDismissForTapSelfWithTouch:touch];
}

#pragma mark - tapGestureRecognizer
-(BOOL)shouldDismissForTapSelfWithTouch:(UITouch*)touch
{
	return (
			(touch.view == self) ||
			(touch.view == self.contentView)
			);
}

@end
