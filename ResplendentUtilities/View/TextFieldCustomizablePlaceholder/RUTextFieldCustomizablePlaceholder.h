//
//  RUTextFieldCustomizablePlaceholder.h
//  Albumatic
//
//  Created by Benjamin Maer on 1/31/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUTextFieldCustomizablePlaceholder : UITextField
{
//    NSUInteger _addLeftPaddingInLayout;
//    BOOL _addLeftPaddingInLayout2;
}

@property (nonatomic, strong) UIColor* placeholderColor;
@property (nonatomic, strong) UIFont* placeholderFont;

@property (nonatomic, assign) CGFloat placeholderLeftPadding;

@end
