//
//  UIViewController+RUStatusBarHeight.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 2/28/15.
//  Copyright (c) 2015 VibeWithIt. All rights reserved.
//

#import "UIViewController+RUStatusBarHeight.h"





@implementation UIViewController (RUStatusBarHeight)

-(CGFloat)ru_statusBarHeightInView
{
	return (CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)) - CGRectGetHeight(self.view.frame);
}

@end
