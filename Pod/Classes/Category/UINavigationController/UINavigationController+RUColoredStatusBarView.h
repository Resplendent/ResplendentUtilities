//
//  UINavigationController+RUColoredStatusBarView.h
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UINavigationController (RUColoredStatusBarView)

@property (nonatomic, strong) UIColor* ru_statusBarBackgroundColor;
@property (nonatomic, readonly) UIView* ru_statusBarBackgroundView;

@end
