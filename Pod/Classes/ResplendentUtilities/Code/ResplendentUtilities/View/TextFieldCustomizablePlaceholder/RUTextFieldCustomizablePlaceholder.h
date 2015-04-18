//
//  RUTextFieldCustomizablePlaceholder.h
//  Resplendent
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUTextFieldCustomizablePlaceholder : UITextField

@property (nonatomic, strong) UIColor* ru_placeholderTextColor;
@property (nonatomic, strong) UIFont* ru_placeholderFont;

@property (nonatomic, assign) UIEdgeInsets ru_textInsets;
@property (nonatomic, assign) UIEdgeInsets ru_placeholderTextInsets;
//@property (nonatomic, assign) CGFloat placeholderLeftPadding;

@property (nonatomic, assign) UIEdgeInsets ru_leftViewInsets;

@property (nonatomic, strong) NSParagraphStyle* ru_placeholderParagraphStyle;
@property (nonatomic, readonly) NSDictionary* ru_placeholderAttributes;

@end
