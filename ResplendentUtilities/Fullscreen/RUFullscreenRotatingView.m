//
//  RUFullscreenRotatingView.m
//  Pineapple
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFullscreenRotatingView.h"

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
        [self addSubview:_contentView];

    }
    return self;
}

#pragma mark - Visibility
-(void)showWithCompletion:(void (^)())completion
{
    
}

#pragma mark - Singleton
RU_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(RUFullscreenRotatingView, sharedInstance);

@end
