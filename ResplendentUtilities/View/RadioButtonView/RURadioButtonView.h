//
//  RURadioButtonView.h
//  Pineapple
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface RURadioButtonView : UIView

@property (nonatomic, strong) NSArray* buttonTitles;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* selectedTextColor;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGFloat buttonPadding;

@property (nonatomic, assign) NSUInteger selectedButtonIndex;

//Meant for subclasses
-(CTFramesetterRef)drawButtonFrameSetterWithRect:(CGRect)button buttonTitle:(NSString *)buttonTitle textColor:(UIColor*)textColor

@end
