//
//  RUCompatability.m
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUCompatability.h"

#import <CoreText/CoreText.h>

@implementation NSAttributedString (RUCompatability)

-(CGSize)ruSizeWithBoundingSize:(CGSize)boundingSize;
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, self.length), NULL, boundingSize, NULL);
    CFRelease(framesetter);
    return size;
}

@end

@implementation UILabel (RUCompatability)

-(void)ruSetMinimumFontSizeScaleFactor:(CGFloat)minimumFontSizeScaleFactor
{
    if ([self respondsToSelector:@selector(setMinimumScaleFactor:)])
    {
        [self setMinimumScaleFactor:minimumFontSizeScaleFactor];
    }
    else
    {
        [self setMinimumFontSize:minimumFontSizeScaleFactor];
    }
}

@end
