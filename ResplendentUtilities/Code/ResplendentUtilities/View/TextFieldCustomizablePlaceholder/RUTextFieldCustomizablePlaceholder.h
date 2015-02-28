//
//  RUTextFieldCustomizablePlaceholder.h
//  Resplendent
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUTextFieldCustomizablePlaceholder : UITextField

@property (nonatomic, strong) UIColor* placeholderTextColor;
@property (nonatomic, strong) UIFont* placeholderFont;

@property (nonatomic, assign) UIEdgeInsets textInsets;
@property (nonatomic, assign) UIEdgeInsets placeholderTextInsets;
//@property (nonatomic, assign) CGFloat placeholderLeftPadding;

@property (nonatomic, assign) UIEdgeInsets leftViewInsets;

@property (nonatomic, strong) NSParagraphStyle* placeholderParagraphStyle;
@property (nonatomic, readonly) NSDictionary* placeholderAttributes;

@end
