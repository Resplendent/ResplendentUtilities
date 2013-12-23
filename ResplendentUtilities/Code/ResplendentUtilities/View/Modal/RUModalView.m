//
//  PAModalView.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/13/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUModalView.h"


@interface RUModalView ()

-(void)didTapSelf:(UITapGestureRecognizer*)tap;

@end

@implementation RUModalView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7f]];

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelf:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }

    return self;
}

#pragma mark - Action methods
-(void)didTapSelf:(UITapGestureRecognizer*)tap
{
    [self dismiss:YES completion:nil];
}

#pragma mark - Public Display Content methods
-(void)showInView:(UIView*)presenterView completion:(void(^)())completion
{
    if (!presenterView)
        [NSException raise:NSInvalidArgumentException format:@"Must pass a non nil presenterView"];

    [self setFrame:presenterView.bounds];
    [presenterView addSubview:self];
    [self setNeedsLayout];
    [self setAlpha:0.0f];

    [UIView animateWithDuration:0.25f animations:^{
        [self setAlpha:1.0f];
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

-(void)dismiss:(BOOL)animate completion:(void(^)())completion
{
    if (animate)
    {
        [UIView animateWithDuration:0.25f animations:^{
            [self setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (completion)
                completion();
        }];
    }
    else
    {
        [self setAlpha:0.0f];
        [self removeFromSuperview];

        if (completion)
            completion();
    }
}

@end

