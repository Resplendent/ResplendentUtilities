//
//  ImageLoadingImageFetchingGridView.m
//  Everycam
//
//  Created by Benjamin Maer on 10/6/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "ImageLoadingImageFetchingGridView.h"
#import "AsynchronousImageView.h"
#import "UIView+Utility.h"

@interface ImageLoadingImageFetchingGridView ()

-(UIView*)addProgressBarAtIndex:(NSUInteger)index;
-(BOOL)removeProgressBarAtIndex:(NSUInteger)index;

@end



@implementation ImageLoadingImageFetchingGridView

@synthesize imageDelegate = _imageDelegate;

-(void)layoutSubviews
{
    [super layoutSubviews];

    for (int index = 0; index < _numberOfLoadingCells; index++)
    {
        UIView* view = [self viewForIndex:index];

        UIView* progressBackgroundBar = [_downloadProgressBarBackgrounds objectAtIndex:index];
        UIView* progressBar = [_downloadProgressBars objectAtIndex:index];

        CGFloat xCoord = floor(CGRectGetWidth(view.frame) * 0.1f);
        [progressBackgroundBar setFrame:CGRectMake(xCoord, floorf(CGRectGetHeight(view.frame) * 0.6), CGRectGetWidth(view.frame) - 2.0f * xCoord, floorf(CGRectGetHeight(view.frame) * 0.3))];

        CGRect frame = progressBackgroundBar.bounds;
        frame.size.width = CGRectGetWidth(progressBar.frame);
        [progressBar setFrame:frame];
    }
}

#pragma mark - Overloaded methods
-(BOOL)deleteCellAtIndex:(NSUInteger)index
{
    if ([super deleteCellAtIndex:index])
    {
        [self removeProgressBarAtIndex:index];
        return YES;
    }

    return NO;
}

#pragma mark - Public methods
-(void)addLoadingImageAtIndex:(NSUInteger)index
{
    _numberOfLoadingCells++;
#if EC_DEBUG
    NSUInteger delegateNumberOfLoadingCells = [_imageDelegate imageGridViewNumberOfLoadingCells:self];
    if (_numberOfLoadingCells != delegateNumberOfLoadingCells)
        NSLog(@"addLoadingImageAtIndex _numberOfLoadingCells: '%i' must = delegate number of loading cells: '%i'",_numberOfLoadingCells,delegateNumberOfLoadingCells);
#endif
    [self insertViewAtIndex:0];
    
}

-(void)finishedLoadingPhotoAtIndex:(NSUInteger)finishedIndex
{
    if (finishedIndex < _numberOfLoadingCells)
    {
        _numberOfLoadingCells--;
        _numberOfLoadedCells++;
#if EC_DEBUG
        NSUInteger delegateNumberOfLoadingCells = [_imageDelegate imageGridViewNumberOfLoadingCells:self];
        if (_numberOfLoadingCells != delegateNumberOfLoadingCells)
            NSLog(@"%s _numberOfLoadingCells: '%i' must = delegate number of loading cells: '%i'",__PRETTY_FUNCTION__,_numberOfLoadingCells,delegateNumberOfLoadingCells);
        NSUInteger delegateNumberOfLoadedCells = [_imageDelegate imageGridViewNumberOfLoadedCells:self];
        if (_numberOfLoadedCells != delegateNumberOfLoadedCells)
            NSLog(@"%s _numberOfLoadedCells: '%i' must = delegate number of loaded cells: '%i'",__PRETTY_FUNCTION__,_numberOfLoadedCells,delegateNumberOfLoadedCells);
#endif
        [self reloadViewAtIndex:_numberOfLoadingCells];
    }
    else
    {
        NSLog(@"finished index %i must be smaller than %i",finishedIndex,_numberOfLoadingCells);
    }
}

-(void)setProgress:(CGFloat)progress forLoadingImageAtIndex:(NSUInteger)index
{
    if (index < _downloadProgressBarBackgrounds.count)
    {
        UIView* progressBackgroundBar = [_downloadProgressBarBackgrounds objectAtIndex:index];
        UIView* progressBar = [_downloadProgressBars objectAtIndex:index];
        setWidth(progressBar, CGRectGetWidth(progressBackgroundBar.frame) * progress);
    }
}

#pragma mark - Setter methods

-(void)setImageDelegate:(id<ImageLoadingImageFetchingGridViewDelegate>)imageDelegate
{
    _imageDelegate = imageDelegate;
    [super setDelegate:self];
    [super setDataSource:self];
}

-(void)setDelegate:(id<GridViewDelegate>)delegate
{
    NSLog(@"ImageLoadingImageFetchingGridView setDelegate this shouldn't happen");
}

#pragma mark - Progress bar methods
-(BOOL)removeProgressBarAtIndex:(NSUInteger)index
{
    if (index < _downloadProgressBarBackgrounds.count)
    {
        UIView* progressBackgroundBar = [_downloadProgressBarBackgrounds objectAtIndex:index];
        UIView* progressBar = [_downloadProgressBars objectAtIndex:index];
        
        [progressBackgroundBar removeFromSuperview];
        [progressBar removeFromSuperview];
        
        [_downloadProgressBarBackgrounds removeObjectAtIndex:index];
        [_downloadProgressBars removeObjectAtIndex:index];

        return YES;
    }

    return NO;
}

-(UIView*)addProgressBarAtIndex:(NSUInteger)index
{
    UIView* progressBackgroundBar = [UIView new];
    [progressBackgroundBar setBackgroundColor:[UIColor grayColor]];
    [progressBackgroundBar setAlpha:0.4f];
    [_downloadProgressBarBackgrounds insertObject:progressBackgroundBar atIndex:index];
    
    UIView* progressBar = [UIView new];
    [progressBar setBackgroundColor:[UIColor blueColor]];
    [progressBackgroundBar addSubview:progressBar];
    [_downloadProgressBars insertObject:progressBar atIndex:index];
    
    return progressBackgroundBar;
}

#pragma mark - GridViewDelegate methods
-(UIView *)gridView:(GridView *)gridView newViewForIndex:(NSUInteger)index
{
    NSInteger numberOfImageCells = _numberOfLoadingCells + _numberOfLoadedCells;
    if (index < numberOfImageCells)
    {
        if (!_downloadProgressBarBackgrounds)
            _downloadProgressBarBackgrounds = [NSMutableArray array];

        if (!_downloadProgressBars)
            _downloadProgressBars = [NSMutableArray array];

        UIImageView* imageView = [UIImageView new];
        [imageView setImage:[_imageDelegate imageGridView:self imageForIndex:index]];

        if (index < _numberOfLoadingCells)
            [imageView addSubview:[self addProgressBarAtIndex:index]];

        return imageView;
    }
    else
    {
        AsynchronousImageView* aImageView = [AsynchronousImageView new];
        [aImageView fetchImageFromURL:[_imageDelegate imageGridView:self urlForIndex:index - numberOfImageCells]];
        [aImageView setFadeInDuration:0.25f];
        [aImageView setViewToSetNeedsLayoutOnComplete:self];
        return aImageView;
    }
}

-(void)gridView:(GridView *)gridView prepareViewForRemoval:(UIView *)view
{
    if ([view isKindOfClass:[AsynchronousImageView class]])
    {
        [(AsynchronousImageView*)view setViewToSetNeedsLayoutOnComplete:nil];
        [(AsynchronousImageView*)view cancelFetch];
    }
}

#pragma mark - GridViewDataSource methods
-(NSUInteger)gridViewNumberOfCells:(GridView *)gridView
{
    _numberOfLoadingCells = [_imageDelegate imageGridViewNumberOfLoadingCells:self];
    _numberOfLoadedCells = [_imageDelegate imageGridViewNumberOfLoadedCells:self];
    _numberOfFetchingCells = [_imageDelegate imageGridViewNumberOfFetchingCells:self];

    return _numberOfLoadingCells + _numberOfFetchingCells;
}

-(NSUInteger)gridViewNumberOfColumns:(GridView *)gridView
{
    return [_imageDelegate imageGridViewNumberOfColumns:self];
}

-(CGFloat)gridViewSpaceBetweenCells:(GridView *)gridView
{
    if ([_imageDelegate respondsToSelector:@selector(imageGridViewSpaceBetweenCells:)])
        return [_imageDelegate imageGridViewSpaceBetweenCells:self];
    else
        return 0;
}

@end
