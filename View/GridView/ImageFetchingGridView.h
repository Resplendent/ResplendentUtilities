//
//  ImageFetchingGridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "GridView.h"

@class ImageFetchingGridView;

@protocol ImageFetchingGridViewDelegate <NSObject>

-(NSString*)imageFetchingGridView:(ImageFetchingGridView*)imageFetchingGridView urlForIndex:(NSUInteger)index;

@end




@interface ImageFetchingGridView : GridView <GridViewDelegate>

@property (nonatomic, assign) id<ImageFetchingGridViewDelegate> imageFetchingDelegate;

@end
