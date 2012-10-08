//
//  ImageLoadingImageFetchingGridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/6/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridView.h"

@class ImageLoadingImageFetchingGridView;

@protocol ImageLoadingImageFetchingGridViewDelegate <NSObject>

-(UIImage *)imageGridView:(ImageLoadingImageFetchingGridView*)imageGridView imageForIndex:(NSUInteger)index;
-(NSString*)imageGridView:(ImageLoadingImageFetchingGridView*)imageGridView urlForIndex:(NSUInteger)index;

-(NSUInteger)imageGridViewNumberOfLoadingCells:(ImageLoadingImageFetchingGridView*)imageGridView;
-(NSUInteger)imageGridViewNumberOfFetchingCells:(ImageLoadingImageFetchingGridView*)imageGridView;

-(NSUInteger)imageGridViewNumberOfColumns:(ImageLoadingImageFetchingGridView*)imageGridView;

@optional
-(CGFloat)imageGridViewSpaceBetweenCells:(ImageLoadingImageFetchingGridView*)imageGridView;

@end



@interface ImageLoadingImageFetchingGridView : GridView <GridViewDelegate, GridViewDataSource>
{
    NSUInteger _numberOfLoadingCells;
    NSUInteger _numberOfFetchingCells;

    NSMutableArray* _downloadProgressBarBackgrounds;
    NSMutableArray* _downloadProgressBars;
}

@property (nonatomic, assign) id<ImageLoadingImageFetchingGridViewDelegate> imageDelegate;

-(void)addLoadingImageAtIndex:(NSUInteger)index;
-(void)finishedLoadingPhotoAtIndex:(NSUInteger)finishedIndex;

-(void)setProgress:(CGFloat)progress forLoadingImageAtIndex:(NSUInteger)index;

@end
