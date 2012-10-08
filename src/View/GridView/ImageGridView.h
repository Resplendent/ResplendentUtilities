//
//  ImageGridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "GridView.h"

@class ImageGridView;

@protocol ImageGridViewDelegate <NSObject>

-(UIImage *)imageGridView:(GridView *)gridView imageForIndex:(NSUInteger)index;

@end




@interface ImageGridView : GridView <GridViewDelegate>

@property (nonatomic, assign) id<ImageGridViewDelegate> imageDelegate;

@end
