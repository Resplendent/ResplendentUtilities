//
//  UIFont+RUConstants.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/4/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRUFontNameWithHelvetica(bold) (bold ? @"Helvetica-Bold" : @"Helvetica")
#define kRUFontWithHelvetica(bold,fontSize) [UIFont fontWithName:kRUFontNameWithHelvetica(bold) size:fontSize]

@interface UIFont (RUConstants)

@end
