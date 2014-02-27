//
//  UIButton+Utility.m
//  Resplendent
//
//  Created by Benjamin Maer on 8/26/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "UIButton+Utility.h"

#define kUIButtonCrossHeightDefault     4.0f

@implementation UIButton (Utility)

#pragma mark - C methods
void setButtonSizeToImageAndCoordinates(UIButton* button, CGFloat xCoord, CGFloat yCoord)
{
    UIImage* image = button.imageView.image;
    
    if (!image)
        image = [button backgroundImageForState:UIControlStateNormal];
    
    if (!image)
        image = [button backgroundImageForState:UIControlStateHighlighted];
    
    if (!image)
        image = [button backgroundImageForState:UIControlStateSelected];
    
    [button setFrame:(CGRect){{xCoord,yCoord},image.size}];
}

void setButtonSizeToImage(UIButton* button)
{
    setButtonSizeToImageAndCoordinates(button, button.frame.origin.x, button.frame.origin.y);
}

CGSize textSizeForButton(UIButton* button)
{
    return [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
}

#pragma mark - Static methods
+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame
{
    return [UIButton buttonCrossWithFrame:buttonFrame crossColor:[UIColor whiteColor]];
}

+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor
{
    return [UIButton buttonCrossWithFrame:buttonFrame crossColor:crossColor crossWidth:CGRectGetWidth(buttonFrame)];
}

+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor crossWidth:(CGFloat)crossWidth
{
    return [UIButton buttonCrossWithFrame:buttonFrame crossColor:crossColor crossSize:CGSizeMake(crossWidth, kUIButtonCrossHeightDefault)];
}

+(UIButton*)buttonCrossWithFrame:(CGRect)buttonFrame crossColor:(UIColor*)crossColor crossSize:(CGSize)crossSize
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor greenColor]];
    [button setFrame:buttonFrame];
    
    CGFloat xCoord = (CGRectGetWidth(buttonFrame) - crossSize.width) / 2.0f;
    CGFloat yCoord = (button.frame.size.height - crossSize.height) / 2.0f;
    UIView* xDiagPiece1 = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, crossSize.width, crossSize.height)];
    [xDiagPiece1 setBackgroundColor:[UIColor whiteColor]];
    [xDiagPiece1 setUserInteractionEnabled:NO];
    xDiagPiece1.transform = CGAffineTransformMakeRotation(M_PI * 1.0f / 4.0f);
    [button addSubview:xDiagPiece1];
    
    UIView* xDiagPiece2 = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, crossSize.width, crossSize.height)];
    [xDiagPiece2 setBackgroundColor:[UIColor whiteColor]];
    [xDiagPiece2 setUserInteractionEnabled:NO];
    xDiagPiece2.transform = CGAffineTransformMakeRotation(M_PI * 3.0f / 4.0f);
    [button addSubview:xDiagPiece2];
    
    return button;
}

@end
