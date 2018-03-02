//
//  RUGradientView.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/22/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSUInteger, RUGradientViewDirection) {
    RUGradientViewDirectionVertical,
    RUGradientViewDirectionHorizontal
};





@interface RUGradientView : UIView

#pragma mark - gradientDirection
@property (nonatomic, assign) RUGradientViewDirection gradientDirection;

#pragma mark - startGradientColor
@property (nonatomic, strong, nullable) IBInspectable UIColor* startGradientColor;

#pragma mark - endGradientColor
@property (nonatomic, strong, nullable) IBInspectable UIColor* endGradientColor;

#pragma mark - init
-(nullable instancetype)initWithStartGradientColor:(nullable UIColor*)startGradientColor
								  endGradientColor:(nullable UIColor*)endGradientColor;

@end
