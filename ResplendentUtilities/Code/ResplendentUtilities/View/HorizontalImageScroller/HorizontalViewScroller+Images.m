//
//  HorizontalViewScroller+Images.m
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller+Images.h"
#import "UIView+Utility.h"

@implementation HorizontalViewScroller (Images)

-(void)addImage:(UIImage*)image
{
    [self addImage:image viewSize:image.size];
}

-(void)addImage:(UIImage*)image viewSize:(CGSize)size
{
    if (!image)
        [NSException raise:NSInvalidArgumentException format:@"Must pass non nil image"];

    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectSetSize(size, imageView.frame)];

    [self addView:imageView];
}

@end
