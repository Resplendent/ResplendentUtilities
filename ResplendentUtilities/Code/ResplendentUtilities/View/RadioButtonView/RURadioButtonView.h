//
//  RURadioButtonView.h
//  Pineapple
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RURadioButtonViewProtocols.h"

@interface RURadioButtonView : UIView
{
    NSArray* _buttons;
}

@property (nonatomic, assign) id<RURadioButtonViewSelectionDelegate> selectionDelegate;

@property (nonatomic, strong) NSArray* buttonTitles;
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* selectedTextColor;

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGFloat buttonPadding;

@property (nonatomic, assign) NSUInteger selectedButtonIndex; //if set to NSNotFound, then none selected
@property (nonatomic, assign) UIButton* selectedButton;

@property (nonatomic, assign) BOOL deSelectButtonOnPress;

//Meant for subclasses
-(UIButton*)newButtonForTitle:(NSString*)title;
//-(CTFramesetterRef)drawButtonFrameSetterWithRect:(CGRect)button buttonTitle:(NSString *)buttonTitle textColor:(UIColor*)textColor;

-(void)pressedButton:(UIButton*)button;

@end
