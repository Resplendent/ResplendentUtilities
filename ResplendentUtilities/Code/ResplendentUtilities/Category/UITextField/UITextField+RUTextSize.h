//
//  UITextField+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UITextField (RUTextSize)

-(CGSize)ruTextSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ruTextSize;

@end
