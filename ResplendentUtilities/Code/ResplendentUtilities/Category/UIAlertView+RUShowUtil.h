//
//  UIAlertView+RUShowUtil.h
//  Resplendent
//
//  Created by Benjamin Maer on 5/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RU_ALERT(title,msg,del,cancel,other,...) [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancel otherButtonTitles:other, ##__VA_ARGS__]

//#define RU_ALERT_SHOW(title,msg,del,cancel,other,...) [RU_ALERT(title,msg,del,cancel,other,##__VA_ARGS__) show]
#define RU_ALERT_SHOW(title,msg,del,cancel,other,...) [RU_ALERT((title),(msg),(del),(cancel),(other),##__VA_ARGS__) show]

@interface UIAlertView (RUShowUtil)

//+(UIAlertView*)ruAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//
//+(void)ruShowAlertViewWithTitle:(NSString*)title message:(NSString*)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
