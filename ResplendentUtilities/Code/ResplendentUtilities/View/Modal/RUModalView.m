//
//  PAModalView.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUModalView.h"





@interface RUModalView ()

@property (nonatomic, assign) BOOL isTransitioning;

-(void)didTapSelf:(UITapGestureRecognizer*)tap;

@end





@implementation RUModalView

@synthesize contentView = _contentView;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7f]];

		[self setTransitionAnimationType:RUModalView_TransitionAnimation_Type_Default];

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelf:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.superview bringSubviewToFront:self];

	if (_contentView)
	{
		[self.contentView setFrame:self.contentViewFrame];
	}
}

#pragma mark - Dynamic Loading
-(UIView *)contentView
{
	if (_contentView == nil)
	{
		_contentView = [UIView new];
		[_contentView setBackgroundColor:[UIColor whiteColor]];
		[_contentView.layer setCornerRadius:5.0f];
		[_contentView setClipsToBounds:YES];
		[self addSubview:_contentView];
	}

	return _contentView;
}

#pragma mark - Action methods
-(void)didTapSelf:(UITapGestureRecognizer*)tap
{
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

    [presenterView addSubview:self];
    [self setFrame:presenterView.bounds];
    [self layoutSubviews];

	[self setAlpha:0.0f];

	switch (self.transitionAnimationType)
	{
		case RUModalView_TransitionAnimation_Type_Fade:
			if (_contentView)
			{
				[self.contentView setAlpha:0.0f];
			}
			break;
			
		case RUModalView_TransitionAnimation_Type_Bottom:
			if (_contentView)
			{
				[self.contentView setFrame:self.contentViewFrameForBottomTransition];
			}
			break;

		case RUModalView_TransitionAnimation_Type_None:
		default:
			break;
	}


    [UIView animateWithDuration:0.25f animations:^{

		[self setAlpha:1.0f];

		switch (self.transitionAnimationType)
		{
			case RUModalView_TransitionAnimation_Type_Fade:
				if (_contentView)
				{
					[self.contentView setAlpha:1.0f];
				}
				break;
				
			case RUModalView_TransitionAnimation_Type_Bottom:
				if (_contentView)
				{
					[self.contentView setFrame:self.contentViewFrame];
				}
				break;

			case RUModalView_TransitionAnimation_Type_None:
			default:
				break;
		}

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

			[self setAlpha:0.0f];

			switch (self.transitionAnimationType)
			{
				case RUModalView_TransitionAnimation_Type_Fade:
					if (_contentView)
					{
						[self.contentView setAlpha:0.0f];
					}
					break;
					
				case RUModalView_TransitionAnimation_Type_Bottom:
					if (_contentView)
					{
						[self.contentView setFrame:self.contentViewFrameForBottomTransition];
					}
					break;
					
				case RUModalView_TransitionAnimation_Type_None:
				default:
					break;
			}

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
-(CGRect)contentViewFrame
{
	static CGFloat const padding = 10.0f;

    return (CGRect){
		.origin.x = padding,
		.origin.y = self.contentViewYCoord,
		.size.width = CGRectGetWidth(self.bounds) - (2.0f * padding),
		.size.height = self.contentViewHeight
    };
}

-(CGFloat)contentViewYCoord
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGFloat)contentViewHeight
{
    RU_METHOD_OVERLOADED_IMPLEMENTATION_NEEDED_EXCEPTION;
}

-(CGFloat)contentViewInnerPadding
{
    return 10;
}

-(CGRect)innerContentViewFrame
{
    CGFloat yCoord = 0;
    
    CGRect contentViewFrame = self.contentViewFrame;
    CGFloat height = CGRectGetHeight(contentViewFrame) - yCoord;
	
    return (CGRect){0,yCoord,CGRectGetWidth(contentViewFrame),height};
}

-(CGRect)contentViewFrameForBottomTransition
{
	return CGRectSetY(CGRectGetHeight(self.bounds), self.contentViewFrame);
}

@end
