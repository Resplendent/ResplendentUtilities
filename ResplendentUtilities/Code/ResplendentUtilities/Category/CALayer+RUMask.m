//
//  CALayer+RUMask.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/14/12.
//  Copyright (c) 2012 Fi. All rights reserved.
//

#import "CALayer+RUMask.h"
#import <QuartzCore/CAShapeLayer.h>





@implementation CALayer (RUMask)

- (UIBezierPath*)applyMaskWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    return applyCALayerMaskWithRoundedCorners(self,corners,radius);
}

UIBezierPath* applyCALayerMaskWithRoundedCorners(CALayer* sourceLayer, UIRectCorner corners,CGFloat radius)
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sourceLayer.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = sourceLayer.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    sourceLayer.mask = maskLayer;

    return maskPath;
}

@end
