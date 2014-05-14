//
//  PAModalView.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RUModalView_TransitionAnimation_Type) {
	RUModalView_TransitionAnimation_Type_None,

	RUModalView_TransitionAnimation_Type_Fade,
	RUModalView_TransitionAnimation_Type_Bottom,

	RUModalView_TransitionAnimation_Type_Default = RUModalView_TransitionAnimation_Type_Fade
};





@interface RUModalView : UIView

@property (nonatomic, readonly) UIView* contentView;
@property (nonatomic, readonly) CGRect contentViewFrame;
@property (nonatomic, readonly) CGFloat contentViewYCoord;
@property (nonatomic, readonly) CGFloat contentViewHeight;
@property (nonatomic, readonly) CGFloat contentViewInnerPadding;
@property (nonatomic, readonly) CGRect innerContentViewFrame;

@property (nonatomic, assign) RUModalView_TransitionAnimation_Type transitionAnimationType;
@property (nonatomic, readonly) CGRect contentViewFrameForBottomTransition;

@property (nonatomic, readonly) UITapGestureRecognizer* tapGestureRecognizer;

-(void)showInView:(UIView*)presenterView completion:(void(^)())completion;
-(void)dismiss:(BOOL)animate completion:(void(^)())completion;

@end
