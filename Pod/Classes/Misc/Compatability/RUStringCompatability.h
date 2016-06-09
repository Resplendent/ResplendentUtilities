//
//  RUCompatability.h
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





//Attributes
#define kRUCompatibleAttributeName(attName6,attName5,attName5BridgeClass) (&attName6 ? attName6 : (__bridge attName5BridgeClass)attName5)

#define kRUCompatibleFont(font) (&NSFontAttributeName ? font : (__bridge id)(CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL)))
#define kRUCompatibleColor(color) (&NSForegroundColorAttributeName ? color : (id)color.CGColor)

#define kRUCompatibleFontAttributeName kRUCompatibleAttributeName(NSFontAttributeName,kCTFontAttributeName,NSString*)
#define kRUCompatibleFontAttributeDictPairWithFont(font) kRUCompatibleFontAttributeName: kRUCompatibleFont(font)

#define kRUCompatibleForegroundColorAttributeName kRUCompatibleAttributeName(NSForegroundColorAttributeName,kCTForegroundColorAttributeName,id)
#define kRUCompatibleForegroundColorAttributeDictPairWithColor(color) kRUCompatibleForegroundColorAttributeName: kRUCompatibleColor(color)

#define kRUCompatibleBackgroundColorAttributeName kRUCompatibleAttributeName(NSBackgroundColorAttributeName,kCTStrokeColorAttributeName,id)
#define kRUCompatibleBackgroundColorAttributeDictPairWithColor(color) kRUCompatibleBackgroundColorAttributeName: kRUCompatibleColor(color)





@interface NSAttributedString (RUStringCompatability)

-(CGSize)ruSizeWithBoundingSize:(CGSize)boundingSize;

@end





@interface UILabel (RUStringCompatability)

-(void)ruSetMinimumFontSizeScaleFactor:(CGFloat)minimumFontSizeScaleFactor;

@end
