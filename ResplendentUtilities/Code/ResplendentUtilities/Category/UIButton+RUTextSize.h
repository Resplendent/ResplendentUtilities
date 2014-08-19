//
//  UIButton+RUTextSize.h
//  Racer Tracer
//
//  Created by Benjamin Maer on 8/18/14.
//  Copyright (c) 2014 Appy Dragon. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIButton (RUTextSize)

-(CGSize)ruCurrentTitleTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ruCurrentTitleTextSize;

@end
