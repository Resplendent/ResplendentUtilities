//
//  CALayer+Mask.h
//  Nickelodeon
//
//  Created by Benjamin Maer on 10/14/12.
//  Copyright (c) 2012 Fi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Mask)

- (UIBezierPath*)applyMaskWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
