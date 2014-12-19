//
//  RURadioButtonView.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>





@class RURadioButtonGroup;





@interface RURadioButtonView : UIView

@property (nonatomic, strong) RURadioButtonGroup* radioButtonGroup;

-(void)setButtonsWithButtonTitles:(NSArray*)buttonTitles;

//@property (nonatomic, strong) NSArray* buttonTitles;

// ++++ The following properties must be set before setting 'buttonTitles' to take effect. Those not marked 'optional' are required.
@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* selectedTextColor; //optional
@property (nonatomic, assign) NSUInteger numberOfRows;
// ----

@property (nonatomic, assign) CGFloat buttonPadding;

//@property (nonatomic, assign) NSUInteger selectedButtonIndex; //if set to NSNotFound, then none selected
//@property (nonatomic, readonly) UIButton* selectedButton;

//Meant for subclasses
-(UIButton*)newButtonAtIndex:(NSUInteger)index withTitle:(NSString*)title;
//-(UIButton*)newButtonForTitle:(NSString*)title;
//-(CTFramesetterRef)drawButtonFrameSetterWithRect:(CGRect)button buttonTitle:(NSString *)buttonTitle textColor:(UIColor*)textColor;

@end
