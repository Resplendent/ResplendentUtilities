//
//  UIColor+Utility.h
//  Memeni
//
//  Created by Benjamin Maer on 8/25/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

inline UIColor* colorWithFloats(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

+(UIColor*)colorWithFloat:(CGFloat)colorFloat alpha:(CGFloat)alpha;

@end
