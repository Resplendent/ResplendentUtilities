//
//  CAShapeLayer+RUMessageBox.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 3/12/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>





@interface CAShapeLayer (RUMessageBox)

#pragma mark - messageBox
+(nonnull CAShapeLayer*)ru_messageBoxMask_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius;
+(nonnull UIBezierPath*)ru_messageBoxPath_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius;
+(CGRect)ru_messageBoxShellRect_with_rect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight;

@end
