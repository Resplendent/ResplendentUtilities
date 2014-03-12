//
//  CAShapeLayer+RUMessageBox.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 3/12/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>





@interface CAShapeLayer (RUMessageBox)

+(CAShapeLayer*)ruMessageBoxMaskForRect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius;
+(CGMutablePathRef)ruMessageBoxPathForRect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight arrowWidth:(CGFloat)arrowWidth arrowLeftPadding:(CGFloat)arrowLeftPadding cornerRadius:(CGFloat)cornerRadius;
+(CGRect)ruMessageBoxShellRectForRect:(CGRect)rect arrowHeight:(CGFloat)arrowHeight cornerRadius:(CGFloat)cornerRadius;

@end
