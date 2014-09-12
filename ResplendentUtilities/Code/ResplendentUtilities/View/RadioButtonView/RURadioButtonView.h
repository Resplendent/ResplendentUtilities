//
//  RURadioButtonView.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RURadioButtonViewProtocols.h"





@interface RURadioButtonView : UIView





@property (nonatomic, assign) id<RURadioButtonViewSelectionDelegate> selectionDelegate;

@property (nonatomic, readonly) NSArray* buttons; //Set by settings the buttonTitle property

@property (nonatomic, strong) NSArray* buttonTitles;

// ++++ The following properties must be set before setting 'buttonTitles' to take effect. Those not marked 'optional' are required.
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* selectedTextColor; //optional
@property (nonatomic, assign) NSUInteger numberOfRows;
// ----

@property (nonatomic, assign) CGFloat buttonPadding;

@property (nonatomic, assign) NSUInteger selectedButtonIndex; //if set to NSNotFound, then none selected
@property (nonatomic, readonly) UIButton* selectedButton;

@property (nonatomic, assign) BOOL deSelectButtonOnPress;

//Meant for subclasses
-(UIButton*)newButtonAtIndex:(NSUInteger)index;
//-(UIButton*)newButtonForTitle:(NSString*)title;
//-(CTFramesetterRef)drawButtonFrameSetterWithRect:(CGRect)button buttonTitle:(NSString *)buttonTitle textColor:(UIColor*)textColor;

-(void)pressedButton:(UIButton*)button;

@end
