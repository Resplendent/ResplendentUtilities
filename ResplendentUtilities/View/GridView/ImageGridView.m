//
//  ImageGridView.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "ImageGridView.h"

@implementation ImageGridView

@synthesize imageDelegate = _imageDelegate;

#pragma mark - Setter methods
-(void)setImageDelegate:(id<ImageGridViewDelegate>)imageDelegate
{
    _imageDelegate = imageDelegate;
    [super setDelegate:self];
}

-(void)setDelegate:(id<GridViewDelegate>)delegate
{
    NSLog(@"this shouldn't happen");
}

#pragma mark - GridViewDelegate methods
-(UIView *)gridView:(GridView *)gridView newViewForIndex:(NSUInteger)index
{
    UIImageView* imageView = [[UIImageView alloc] init];
    [imageView setImage:[_imageDelegate imageGridView:self imageForIndex:index]];
    return imageView;
}

@end
