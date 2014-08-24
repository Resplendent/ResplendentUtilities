//
//  UIView+RUDrawHole.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 3/12/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIView (RUDrawHole)

-(void)drawHoleInRect:(CGRect)rect radius:(CGFloat)radius context:(CGContextRef)context;

@end
