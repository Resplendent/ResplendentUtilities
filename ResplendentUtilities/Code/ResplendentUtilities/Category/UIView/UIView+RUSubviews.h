//
//  UIView+RUSubviews.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 6/24/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIView (RUSubviews)

@property (nonatomic, readonly) UIView* ruLowestSubview;
@property (nonatomic, readonly) UIView* ruFirstResponderSubview;

-(UIView*)ru_frontMostSubviewOfPoint:(CGPoint)point withEvent:(UIEvent *)event;

@end
