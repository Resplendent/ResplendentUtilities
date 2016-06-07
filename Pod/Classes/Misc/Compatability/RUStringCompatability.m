//
//  RUCompatability.m
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUStringCompatability.h"

#import <CoreText/CoreText.h>





@implementation NSAttributedString (RUStringCompatability)

-(CGSize)ruSizeWithBoundingSize:(CGSize)boundingSize;
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, self.length), NULL, boundingSize, NULL);
    CFRelease(framesetter);
    return size;
}

@end





@implementation UILabel (RUStringCompatability)

-(void)ruSetMinimumFontSizeScaleFactor:(CGFloat)minimumFontSizeScaleFactor
{
    if ([self respondsToSelector:@selector(setMinimumScaleFactor:)])
    {
        [self setMinimumScaleFactor:minimumFontSizeScaleFactor];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self setMinimumFontSize:minimumFontSizeScaleFactor];
#pragma clang diagnostic pop
    }
}

@end
