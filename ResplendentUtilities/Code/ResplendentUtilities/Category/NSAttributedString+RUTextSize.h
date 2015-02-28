//
//  NSAttributedString+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/4/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface NSAttributedString (RUTextSize)

- (CGSize)ru_textSizeWithBoundingWidth:(CGFloat)boundingWidth;

@end
