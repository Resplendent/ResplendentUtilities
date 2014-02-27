//
//  RUCornerRoundingBorderedView.h
//  Resplendent
//
//  Created by Benjamin Maer on 2/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUCornerRoundingBorderedView : UIView
{
    UIBezierPath* _path;
    UIImageView* _icon;
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

//Icon
//@property (nonatomic, readonly) UIImageView* icon;
@property (nonatomic, assign) UIImage* iconImage;
@property (nonatomic, readonly) CGRect iconFrame;
@property (nonatomic, assign) CGFloat iconLeftPadding;

-(void)addIcon;

//TextField
@property (nonatomic, readonly) UITextField* textField;
@property (nonatomic, readonly) CGRect textFieldFrame;
@property (nonatomic, assign) CGFloat textFieldLeftPadding;

-(void)addTextField;

@end
