//
//  RUGradientView.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/22/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUGradientView : UIView
//{
//    CGGradientRef _gradientRef;
//}

@property (nonatomic,strong) UIColor* topGradientColor;
@property (nonatomic,strong) UIColor* bottomGradientColor;

+(instancetype)gradientViewWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor;

@end
