//
//  UIColor+Utility.m
//  Memeni
//
//  Created by Benjamin Maer on 8/25/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

UIColor* colorWithFloats(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha)
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}

+(UIColor*)colorWithFloat:(CGFloat)colorFloat alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:colorFloat/255.0f green:colorFloat/255.0f blue:colorFloat/255.0f alpha:alpha];
}

@end
