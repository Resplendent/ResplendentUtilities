//
//  RUCredentialInputView.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUCredentialInputView : UIView
{
    UIBezierPath* _path;
}

@property (nonatomic, readonly) UITextField* inputTextField;
@property (nonatomic, readonly) CGRect inputTextFieldFrame;

@property (nonatomic, assign) CGFloat textFieldHorizontalPadding;

@property (nonatomic, assign) UIRectCorner cornerMasks;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor* borderColor;

@end
