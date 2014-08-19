//
//  NSString+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 8/7/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSString (RUTextSize)

- (CGSize)textSizeWithBoundingWidth:(CGFloat)boundingWidth attributes:(NSDictionary *)attributes NS_AVAILABLE_IOS(7_0);

@end
