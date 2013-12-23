//
//  UIButton+Utility.h
//  Albumatic
//
//  Created by Benjamin Maer on 8/26/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UILabel+Utility.h"
#import "UIView+RUUtility.h"

extern void setButtonSizeToImageAndCoordinates(UIButton* button, CGFloat xCoord, CGFloat yCoord);

extern void setButtonSizeToImage(UIButton* button);

extern CGSize textSizeForButton(UIButton* button);

@interface UIButton (Utility)

+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame;
+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor;
+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor crossWidth:(CGFloat)crossWidth;
+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor crossSize:(CGSize)crossSize;

@end
