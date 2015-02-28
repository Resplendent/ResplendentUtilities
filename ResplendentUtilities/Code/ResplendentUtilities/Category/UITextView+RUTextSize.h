//
//  UITextView+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 1/16/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UITextView (RUTextSize)

-(CGSize)ru_textSizeConstrainedToWidth:(CGFloat)width;
-(CGSize)ru_textSize;

@end
