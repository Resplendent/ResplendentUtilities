//
//  CALayer+RUMask.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/14/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "CALayer+RUMask.h"
#import <QuartzCore/CAShapeLayer.h>





@implementation CALayer (RUMask)

- (UIBezierPath*)applyMaskWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];

	// Create the shape layer and set its path
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.frame = self.bounds;
	maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.mask = maskLayer;

	return maskPath;
}

@end
