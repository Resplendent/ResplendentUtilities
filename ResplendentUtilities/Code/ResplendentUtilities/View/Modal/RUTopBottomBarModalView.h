//
//  PAContentModalView.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/29/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUModalView.h"





@class RUGradientButton;





extern CGFloat const kPAContentModalViewTopBarButtonHeight;





@interface RUTopBottomBarModalView : RUModalView <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) CGFloat contentViewHorizontalInnerPadding;

//++++ Top Bar
@property (nonatomic, assign) BOOL enableTopBar;
@property (nonatomic, readonly) UIView* topBar;
@property (nonatomic, readonly) CGRect topBarFrame;
@property (nonatomic, readonly) CGFloat topBarHeight;

@property (nonatomic, readonly) RUGradientButton* topBarButton;
@property (nonatomic, readonly) CGRect topBarButtonFrame;
@property (nonatomic, readonly) CGFloat topBarButtonWidth;

@property (nonatomic, readonly) UILabel* topBarLabel;
@property (nonatomic, readonly) Class topBarLabelClass;
@property (nonatomic, readonly) CGRect topBarLabelFrame;
@property (nonatomic, readonly) CGFloat topBarLabelRightBoundary;

@property (nonatomic, readonly) UIView* topBarUnderline;
@property (nonatomic, readonly) CGRect topBarUnderlineFrame;

-(void)pressedTopBarButton:(UIButton*)button;
//----

//++++ Bottom Bar
@property (nonatomic, assign) BOOL enableBottomBar;
@property (nonatomic, readonly) UIView* bottomBar;
@property (nonatomic, readonly) CGRect bottomBarFrame;
@property (nonatomic, readonly) CGFloat bottomBarHeight;

@property (nonatomic, readonly) RUGradientButton* bottomBarButton;
@property (nonatomic, readonly) CGRect bottomBarButtonFrame;
@property (nonatomic, readonly) CGFloat bottomBarButtonWidth;

@property (nonatomic, readonly) UILabel* bottomBarLabel;
@property (nonatomic, readonly) Class bottomBarLabelClass;
@property (nonatomic, readonly) CGRect bottomBarLabelFrame;
@property (nonatomic, readonly) CGFloat bottomBarLabelRightBoundary;

@property (nonatomic, readonly) UIView* bottomBarOverline;
@property (nonatomic, readonly) CGRect bottomBarOverlineFrame;

-(void)pressedBottomBarButton:(UIButton*)button;
//----

@end
