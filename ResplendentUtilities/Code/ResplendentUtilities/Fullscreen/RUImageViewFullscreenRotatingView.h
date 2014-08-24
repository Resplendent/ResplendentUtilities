//
//  RUImageViewFullscreenRotatingView.h
//  Resplendent
//
//  Created by Benjamin Maer on 9/10/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUFullscreenRotatingView.h"

@interface RUImageViewFullscreenRotatingView : RUFullscreenRotatingView
{
    UIImageView* _sourceImageView;
    UIImageView* _animationTransitionImageView;

    CGRect _convertedOriginalFrame;
}

//Can be overloaded. The image it returns will be the image animated out on _animationTransitionImageView
//If nil is returned, it will use the image it animated in with.
@property (nonatomic, readonly) UIImage* imageForHide;

-(void)showWithImageView:(UIImageView*)imageView onView:(UIView *)view completion:(void (^)(BOOL didShow))completion;

@end
