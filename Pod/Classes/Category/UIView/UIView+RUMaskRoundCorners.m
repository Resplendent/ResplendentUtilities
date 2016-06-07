//
//  UIView+RUMaskRoundCorners.m
//  Resplendent
//
//  Created by Benjamin Maer on 5/28/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "UIView+RUMaskRoundCorners.h"
#import "CALayer+RUMask.h"

#import <objc/runtime.h>

NSString* const kUIViewRUMaskRoundCornersPrivateAssociatedObjectKeyMaskBezierPath = @"kUIViewRUMaskRoundCornersPrivateAssociatedObjectKeyMaskBezierPath";

@interface UIView (RUMaskRoundCornersPrivate)

@property (nonatomic, strong) UIBezierPath* ruMaskRoundCornersPrivateMaskBezierPath;

@end

@implementation UIView (RUMaskRoundCorners)

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    if (corners == UIRectCornerAllCorners)
    {
        if (self.ruMaskRoundCornersPrivateMaskBezierPath)
        {
            [self setRuMaskRoundCornersPrivateMaskBezierPath:nil];
            [self.layer setMask:nil];
        }

        [self.layer setCornerRadius:radius];
        [self.layer setMasksToBounds:YES];
    }
    else
    {
        [self.layer setCornerRadius:0];

        // If we want to choose which corners we want to mask then
        // it is necessary to create a mask layer.
        [self setRuMaskRoundCornersPrivateMaskBezierPath:[self.layer applyMaskWithRoundedCorners:corners radius:radius]];
    }
}

@end

@implementation UIView (RUMaskRoundCornersPrivate)

-(UIBezierPath *)ruMaskRoundCornersPrivateMaskBezierPath
{
    return objc_getAssociatedObject(self, &kUIViewRUMaskRoundCornersPrivateAssociatedObjectKeyMaskBezierPath);
}

-(void)setRuMaskRoundCornersPrivateMaskBezierPath:(UIBezierPath *)ruMaskRoundCornersPrivateMaskBezierPath
{
    objc_setAssociatedObject(self, &kUIViewRUMaskRoundCornersPrivateAssociatedObjectKeyMaskBezierPath, ruMaskRoundCornersPrivateMaskBezierPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
