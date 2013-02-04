//
//  RUCornerRoundingBorderedView.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUCornerRoundingBorderedView : UIView
{
    UIBezierPath* _path;
}

@property (nonatomic, assign) UIRectCorner cornerMasks;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor* borderColor;

//Switcher
@property (nonatomic, readonly) UISwitch* switcher;
@property (nonatomic, readonly) CGRect switcherFrame;
@property (nonatomic, assign) CGFloat switcherRightPadding;

-(void)addSwitcher;

//Label
@property (nonatomic, readonly) UILabel* label;
@property (nonatomic, readonly) CGRect labelFrame;
@property (nonatomic, assign) CGFloat labelLeftPadding;

-(void)addLabel;


@end




@interface RUCornerRoundingBorderedView (TextField)

extern NSString* const kRUCornerRoundingBorderedViewTextFieldObservingKey;

@property (nonatomic, readonly) UITextField* inputTextField;
@property (nonatomic, readonly) CGRect inputTextFieldFrame;

//@property (nonatomic, assign) CGFloat textFieldHorizontalPadding;
-(void)setTextFieldHorizontalPadding:(CGFloat)textFieldHorizontalPadding;

-(void)addInputTextField;
-(void)layoutInputTextField;

@end



//@interface RUCornerRoundingBorderedView (Switcher)
//
//extern NSString* const kRUCornerRoundingBorderedViewSwitcherObservingKey;
//
//@property (nonatomic, readonly) UISwitch* switcher;
//@property (nonatomic, readonly) CGRect switcherFrame;
//
//-(void)setSwitcherHorizontalPadding:(CGFloat)textFieldHorizontalPadding;
//
//-(void)addSwitcher;
//-(void)layoutSwitcher;
//
//@end


