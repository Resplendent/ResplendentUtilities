//
//  RUFullscreenRotatingView.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFullscreenRotatingView.h"

@implementation RUFullscreenRotatingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self setClipsToBounds:NO];

        _contentView = [UIView new];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];

    }
    return self;
}

#pragma mark - Visibility
-(void)showWithCompletion:(void (^)())completion
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
