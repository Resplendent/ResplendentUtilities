//
//  Navbar.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface Navbar : UIView

@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, readonly) UIView* animatableContentView;
@property (nonatomic, readonly) CGRect animatableContentViewFrame;
@property (nonatomic, readonly) CGFloat animatableContentViewHeight;
@property (nonatomic, readonly) CGFloat animatableContentViewLowerPadding;

@property (nonatomic, readonly) CGRect titleLabelFrame;

@property (nonatomic, retain) NIAttributedLabel* titleLabel;
@property (nonatomic, assign) CGFloat titleLabelTopEdgeInset;

@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIButton* rightButton;

@property (nonatomic, strong) NSNumber* leftButtonLeftPadding;
@property (nonatomic, strong) NSNumber* rightButtonRightPadding;

//-(id)initWithFrame:(CGRect)frame autoAdjustButtons:(BOOL)autoAdjustButtons;

//-(void)setAlphaForComponents:(CGFloat)alpha;

-(CGRect)leftButtonFrameWithAnimatableContentViewFrame:(CGRect)animatableContentViewFrame;
-(CGRect)rightButtonFrameWithAnimatableContentViewFrame:(CGRect)animatableContentViewFrame;

@end
