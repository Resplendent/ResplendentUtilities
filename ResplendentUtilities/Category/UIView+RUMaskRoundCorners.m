//
//  UIView+RUMaskRoundCorners.m
//  Pineapple
//
//  Created by Benjamin Maer on 5/28/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "UIView+RUMaskRoundCorners.h"
#import "CALayer+Mask.h"

@implementation UIView (RUMaskRoundCorners)

- (void)maskRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    if (corners == UIRectCornerAllCorners)
    {
        [self.layer setCornerRadius:radius];
        [self.layer setMasksToBounds:YES];
    }
    else
    {
        // If we want to choose which corners we want to mask then
        // it is necessary to create a mask layer.
        [self.layer applyMaskWithRoundedCorners:corners radius:radius];
    }
}

@end
