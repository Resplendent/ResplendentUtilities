//
//  RUCompatability.m
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUCompatability.h"
#import "RUSystemVersionUtils.h"

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





@implementation RUCompatabilityConstants

+(BOOL)screenSizeIs568
{
    static NSNumber* __RUCompatabilityConstants__screenSizeIs568;
    if (!__RUCompatabilityConstants__screenSizeIs568)
    {
        __RUCompatabilityConstants__screenSizeIs568 = @([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
    }

    return __RUCompatabilityConstants__screenSizeIs568.boolValue;
}

+(BOOL)iOSVersionAtLeast7
{
    static NSNumber* __RUCompatabilityConstants__IOSVersionAtLeast7;
    if (!__RUCompatabilityConstants__IOSVersionAtLeast7)
    {
        __RUCompatabilityConstants__IOSVersionAtLeast7 = @(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"));
    }

    return __RUCompatabilityConstants__IOSVersionAtLeast7.boolValue;
}

@end
