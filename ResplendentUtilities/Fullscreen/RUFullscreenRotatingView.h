//
//  RUFullscreenRotatingView.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    RUFullscreenRotatingViewStateHiding = 0,
    RUFullscreenRotatingViewStateMovingToShow,
    RUFullscreenRotatingViewStateShowing,
    RUFullscreenRotatingViewStateMovingToHide,
}RUFullscreenRotatingViewState;

@interface RUFullscreenRotatingView : UIView
{
    UIView* _contentView;
    UIView* _shadowView;
}

@property (nonatomic, assign) UIView* presenterView;

@property (nonatomic, readonly) RUFullscreenRotatingViewState state;

@property (nonatomic, readonly) CGRect adjustedContentViewFrame;

@property (nonatomic, readonly) BOOL readyToShow;
@property (nonatomic, readonly) BOOL readyToHide;

-(void)showWithCompletion:(void (^)())completion;
-(void)hide;

-(void)hideAnimated:(BOOL)animated completion:(void(^)(BOOL didHide))completion;

@end
