//
//  RUImageViewFullscreenRotatingView.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/10/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFullscreenRotatingView.h"

@interface RUImageViewFullscreenRotatingView : RUFullscreenRotatingView
{
    UIImageView* _sourceImageView;
    UIImageView* _animationTransitionImageView;

    CGRect _convertedOriginalFrame;
}

-(void)showWithImageView:(UIImageView*)imageView completion:(void (^)(BOOL didShow))completion;

@end
