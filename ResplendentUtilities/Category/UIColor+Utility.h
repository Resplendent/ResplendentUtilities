//
//  UIColor+Utility.h
//  Memeni
//
//  Created by Benjamin Maer on 8/25/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UIColor (Utility)

//inline UIColor* colorWithFloats(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

+(UIColor*)colorWithFloat:(CGFloat)colorFloat alpha:(CGFloat)alpha;

@end
