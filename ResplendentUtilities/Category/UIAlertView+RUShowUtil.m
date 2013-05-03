//
//  UIAlertView+RUShowUtil.m
//  Albumatic
//
//  Created by Benjamin Maer on 5/3/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIAlertView+RUShowUtil.h"

@implementation UIAlertView (RUShowUtil)

+(UIAlertView*)ruAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
}

+(void)ruShowAlertViewWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    [[self amAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil]show];
}


@end
