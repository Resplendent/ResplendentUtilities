//
//  UILabel+RUTextSize.h
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UILabel (RUTextSize)

-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ruTextSize;

@end
