//
//  ImageFetchingGridView.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "ImageFetchingGridView.h"
#import "AsynchronousImageView.h"

@implementation ImageFetchingGridView

@synthesize imageFetchingDelegate = _imageFetchingDelegate;

#pragma mark - Setter methods
-(void)setImageFetchingDelegate:(id<ImageFetchingGridViewDelegate>)imageFetchingDelegate
{
    _imageFetchingDelegate = imageFetchingDelegate;
    [super setDelegate:self];
}

-(void)setDelegate:(id<GridViewDelegate>)delegate
{
    NSLog(@"this shouldn't happen");
}


#pragma mark - GridViewDelegate methods
-(UIView *)gridView:(GridView *)gridView newViewForIndex:(NSUInteger)index
{
    AsynchronousImageView* aImageView = [[AsynchronousImageView alloc] init];
    [aImageView fetchImageFromURL:[_imageFetchingDelegate imageFetchingGridView:self urlForIndex:index]];
    return aImageView;
}

-(void)gridView:(GridView *)gridView prepareViewForRemoval:(UIView *)view
{
    if ([view isKindOfClass:[AsynchronousImageView class]])
        [(AsynchronousImageView*)view cancelFetch];
}

@end
