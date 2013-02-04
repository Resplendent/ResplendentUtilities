//
//  RUCredentialInputView.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUCornerRoundingBorderedView.h"

@interface RUCredentialInputView : RUCornerRoundingBorderedView

@property (nonatomic, readonly) UITextField* inputTextField;
@property (nonatomic, readonly) CGRect inputTextFieldFrame;

@property (nonatomic, assign) CGFloat textFieldHorizontalPadding;

@end

