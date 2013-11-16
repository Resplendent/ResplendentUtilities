//
//  UIView+RUEnableTapToResignFirstResponder.h
//  Pineapple
//
//  Created by Benjamin Maer on 11/12/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RUEnableTapToResignFirstResponder)

@property (nonatomic, readonly) UIView* ruSelfOrSubviewFirstResponder;

@property (nonatomic, readonly) UITapGestureRecognizer* ruEnableTapToResignFirstResponderTap;
@property (nonatomic, assign) BOOL ruEnableTapToResignFirstResponder;

@end
