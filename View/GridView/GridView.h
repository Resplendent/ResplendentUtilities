//
//  GridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;

@protocol GridViewDelegate <NSObject>

-(UIView*)gridView:(GridView*)gridView newViewForIndex:(NSUInteger)index;

@optional
-(void)gridView:(GridView*)gridView prepareViewForRemoval:(UIView*)view;

@end

@protocol GridViewDataSource <NSObject>

-(NSUInteger)gridViewNumberOfCells:(GridView*)gridView;
-(NSUInteger)gridViewNumberOfColumns:(GridView*)gridView;

@optional
-(CGFloat)gridViewSpaceBetweenCells:(GridView*)gridView;

@end



@interface GridView : UIView <UIScrollViewDelegate>
{
    NSMutableDictionary* _cellsDictionary;
    UIScrollView* _scrollView;

    //Gotten from delegates
    CGFloat _spaceBetweenCells;
    NSUInteger _numberOfCells;
    NSUInteger _numberOfColumns;

    //Calculated after delegates
    CGFloat _modifiedSpaceBetweenCells;
    CGFloat _cellWidth;
    NSUInteger _numberOfRows;
}

@property (nonatomic, assign) id<GridViewDelegate> delegate;
@property (nonatomic, assign) id<GridViewDataSource> dataSource;

-(void)reloadData;

-(void)insertViewAtIndex:(NSUInteger)index;
-(void)removeViewAtIndex:(NSUInteger)index;
-(void)reloadViewAtIndex:(NSUInteger)index;
-(void)switchViewsAtFirstIndex:(NSUInteger)firstIndex secondIndex:(NSUInteger)secondIndex;

-(UIView*)viewForIndex:(NSUInteger)index;

@end
