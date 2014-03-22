//
//  UIColor+RUUtility.h
//  Resplendent
//
//  Created by Benjamin Maer on 8/25/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>





#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWA(w, a) [UIColor colorWithWhite:w/255.0 alpha:a]





@interface UIColor (RUUtility)

+(UIColor*)colorWithFloat:(CGFloat)colorFloat alpha:(CGFloat)alpha;

@end
