//
//  RUKeyboardAdjustmentHelper.m
//  Resplendent
//
//  Created by Benjamin Maer on 10/6/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUKeyboardAdjustmentHelper.h"





@interface RUKeyboardAdjustmentHelper ()

-(void)notificationFiredKeyboardWillShow:(NSNotification*)notification;
-(void)notificationFiredKeyboardWillHide:(NSNotification*)notification;

+(CGFloat)keyboardTopFromKeyboardEndFrame:(CGRect)keyboardEndFrame;

@end





@implementation RUKeyboardAdjustmentHelper

-(void)dealloc
{
    [self setRegisteredForKeyboardNotifications:NO];
}

#pragma mark - Keyboard Notifications
-(void)setRegisteredForKeyboardNotifications:(BOOL)registeredForKeyboardNotifications
{
    if (self.registeredForKeyboardNotifications == registeredForKeyboardNotifications)
        return;
    
    _registeredForKeyboardNotifications = registeredForKeyboardNotifications;
    
    if (self.registeredForKeyboardNotifications)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationFiredKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationFiredKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void)notificationFiredKeyboardWillShow:(NSNotification*)notification
{
    NSValue* keyboardEndFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardTop = @([self.class keyboardTopFromKeyboardEndFrame:keyboardEndFrameValue.CGRectValue]);
    
    NSNumber* duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    [self.delegate keyboardAdjustmentHelper:self willShowWithAnimationDuration:duration.doubleValue];
}

-(void)notificationFiredKeyboardWillHide:(NSNotification*)notification
{
    _keyboardTop = nil;
    
    NSNumber* duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [self.delegate keyboardAdjustmentHelper:self willHideWithAnimationDuration:duration.doubleValue];
}

#pragma mark - Keyboard Top
+(CGFloat)keyboardTopFromKeyboardEndFrame:(CGRect)keyboardEndFrame
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? CGRectGetWidth(keyboardEndFrame) : CGRectGetHeight(keyboardEndFrame);
}

@end
