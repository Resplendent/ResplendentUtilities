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

@property (nonatomic, assign) RUGradientViewDirection gradientDirection;

@property (nonatomic,strong) UIColor* startGradientColor;
@property (nonatomic,strong) UIColor* endGradientColor;

-(id)initWithStartGradientColor:(UIColor*)startGradientColor endGradientColor:(UIColor*)endGradientColor;

@end
