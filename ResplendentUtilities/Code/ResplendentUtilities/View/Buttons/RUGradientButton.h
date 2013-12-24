//
//  RUGradientButton.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUGradientButton : UIButton
{
    CGGradientRef _gradientRef;
    NSArray* _colors;
}

@property (nonatomic,strong) UIColor* topGradientColor;
@property (nonatomic,strong) UIColor* bottomGradientColor;

@end
