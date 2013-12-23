//
//  UIFont+RUConstants.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/4/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRUFontNameWithHelvetica(bold) (bold ? @"Helvetica-Bold" : @"Helvetica")
#define kRUFontWithHelvetica(isBold,fontSize) [UIFont fontWithName:kRUFontNameWithHelvetica(isBold) size:fontSize]

@interface UIFont (RUConstants)

@end
