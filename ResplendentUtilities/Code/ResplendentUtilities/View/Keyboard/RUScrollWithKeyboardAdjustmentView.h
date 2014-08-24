//
//  RUScrollWithKeyboardAdjustmentView.h
//  Resplendent
//
//  Created by Benjamin Maer on 12/21/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUKeyboardAdjustmentHelperProtocols.h"





@interface RUScrollWithKeyboardAdjustmentView : UIView <RUKeyboardAdjustmentHelperDelegate>
{
    RUKeyboardAdjustmentHelper* _keyboardHelper;
}

@property (nonatomic, readonly) UIScrollView* scrollView;

@property (nonatomic, assign) CGFloat scrollViewBottomPadding;
@property (nonatomic, assign) CGFloat scrollViewBottomKeyboardPadding;

@property (nonatomic, readonly) CGSize scrollViewContentSize;
@property (nonatomic, readonly) CGFloat scrollViewContentSizeHeight;

@property (nonatomic, assign) BOOL disableKeyboardAdjustment;

-(id)initWithScrollView:(UIScrollView*)scrollView;

-(void)addSubviewToScrollView:(UIView*)view;

@end
