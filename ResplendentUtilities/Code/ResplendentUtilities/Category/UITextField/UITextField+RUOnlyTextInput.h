//
//  UITextField+RUOnlyTextInput.h
//  Nifti
//
//  Created by Benjamin Maer on 12/14/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UITextField (RUOnlyTextInput)

- (BOOL)ru_isOnlyTextInputWithTextChangeInRange:(NSRange)range replacementString:(NSString *)string;

@end
