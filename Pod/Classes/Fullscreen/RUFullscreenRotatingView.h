//
//  RUFullscreenRotatingView.h
//  Resplendent
//
//  Created by Benjamin Maer on 9/3/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUFullscreenRotatingViewProtocols.h"





typedef enum{
    RUFullscreenRotatingViewStateHiding = 0,
    RUFullscreenRotatingViewStateMovingToShow,
    RUFullscreenRotatingViewStateShowing,
    RUFullscreenRotatingViewStateMovingToHide,
}RUFullscreenRotatingViewState;





@interface RUFullscreenRotatingView : UIView

#pragma mark - shadowView
@property (nonatomic, strong, nullable) UIView* shadowView;

@property (nonatomic, readonly, nullable) UIView* contentView;
@property (nonatomic, readonly, nullable) UITapGestureRecognizer* contentViewTapToDismissGesture;

@property (nonatomic, assign, nullable) id<RUFullscreenRotatingViewHideDelegate> hideDelegate;

@property (nonatomic, assign) BOOL forceLayoutSubviewsOnTransition;

@property (nonatomic, assign) NSTimeInterval showAnimationDuration;
@property (nonatomic, assign) NSTimeInterval hideAnimationDuration;
@property (nonatomic, assign) NSTimeInterval rotationAnimationDuration;

@property (nonatomic, assign) RUFullscreenRotatingViewState state;

@property (nonatomic, readonly) CGRect adjustedContentViewFrame;

@property (nonatomic, readonly) BOOL readyToShow;
@property (nonatomic, readonly) BOOL preparedToShow;
@property (nonatomic, readonly) BOOL readyToHide;

-(void)showOnView:(nullable UIView*)view completion:(nullable void (^)(BOOL didShow))completion;

-(void)hide;
-(void)hideAnimated:(BOOL)animated completion:(nullable void(^)(BOOL didHide))completion;

//Meant for subclassing, shouldn't be called directly. Subclasses must call their super
-(void)willPerformShowAnimation;
-(void)performShowAnimation;
-(void)didShow;

-(void)willPerformHideAnimation;
-(void)performHideAnimation;
-(void)didHide;

//Meant to be subclassed, shouldn't be called directly.
-(void)willTransitionToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
-(void)transitionToOrientation:(UIInterfaceOrientation)orientation didUpdateOrientation:(BOOL)didUpdateOrientation;

@end
