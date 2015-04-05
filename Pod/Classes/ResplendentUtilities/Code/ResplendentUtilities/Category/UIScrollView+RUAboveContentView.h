//
//  UIScrollView+RUAboveContentView.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/4/15.
//  Copyright (c) 2015 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIScrollView (RUAboveContentView)

@property (nonatomic, assign) BOOL ru_UIScrollView_enableAboveContentView;
@property (nonatomic, readonly) UIView* ru_UIScrollView_aboveContentView;

@end
