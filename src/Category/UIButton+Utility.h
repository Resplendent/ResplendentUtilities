//
//  UIButton+Utility.h
//  Memeni
//
//  Created by Benjamin Maer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILabel+Utility.h"
#import "UIView+Utility.h"

CG_INLINE void setSizeToImageAndCoordinates(UIButton* button, CGFloat xCoord, CGFloat yCoord)
{
    UIImage* image = button.imageView.image;
    
    if (!image)
        image = [button backgroundImageForState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(xCoord, yCoord, image.size.width, image.size.height)];
}

CG_INLINE void setSizeToImage(UIButton* button)
{
    setSizeToImageAndCoordinates(button, button.frame.origin.x, button.frame.origin.y);
}

CG_INLINE CGSize textSizeForButton(UIButton* button)
{
    return [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
}

@interface UIButton (Utility)

+(UIButton*)buttonWithCrossFrame:(CGRect)frame;
+(UIButton*)buttonWithCrossFrame:(CGRect)frame crossColor:(UIColor*)crossColor;
+(UIButton*)buttonWithCrossFrame:(CGRect)frame crossColor:(UIColor*)crossColor crossHeight:(CGFloat)crossHeight;

@end
