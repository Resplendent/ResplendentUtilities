//
//  HorizontalViewScroller+ImageFromUrl.m
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller+ImageFromUrl.h"
#import "AsynchronousImageView.h"
#import "RUConstants.h"
#import <QuartzCore/CALayer.h>

@implementation HorizontalViewScroller (ImageFromUrl)

-(void)addImageFromUrlString:(NSString*)urlString size:(CGSize)size
{
    [self addImageFromUrl:[NSURL URLWithString:urlString] size:size];
}

-(void)addImageFromUrl:(NSURL*)url size:(CGSize)size
{
    if (!url)
        [NSException raise:NSInvalidArgumentException format:@"Must pass non nil url"];

    AsynchronousImageView* imageView = [AsynchronousImageView new];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setFrame:(CGRect){0,0,size}];
    [imageView fetchImageFromURL:url];
    [imageView setClipsToBounds:YES];
    [imageView.layer setCornerRadius:4.0f];

    [self addView:imageView];
}

@end
