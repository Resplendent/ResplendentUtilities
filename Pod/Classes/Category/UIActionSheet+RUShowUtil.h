//
//  UIActionSheet+RUShowUtil.h
//  Resplendent
//
//  Created by Benjamin Maer on 5/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RU_ACTION_SHEET(title,del,cancel,destruct,other,...) [[UIActionSheet alloc] initWithTitle:title delegate:del cancelButtonTitle:cancel destructiveButtonTitle:destruct otherButtonTitles:other, ##__VA_ARGS__]

#define RU_ACTION_SHEET_SHOW(view,title,msg,del,cancel,other,...) [RU_ACTION_SHEET((title),(del),(cancel),(destruct),(other),##__VA_ARGS__) showInView:view]

//@interface UIActionSheet (RUShowUtil)
//
//+(UIActionSheet*)ruActionSheetWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//
//+(void)ruShowActionSheetInView:(UIView*)view withTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//
//@end
