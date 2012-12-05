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

@protocol GridViewDataSourceSelectionDelegate <NSObject>

-(void)gridView:(GridView*)gridView didSelectViewAtIndex:(NSUInteger)index;

@end



@interface GridView : UIView <UIScrollViewDelegate>
{
    NSMutableDictionary* _cellsDictionary;

    //Gotten from delegates
    CGFloat _spaceBetweenCells;
    NSUInteger _numberOfCells;
    NSUInteger _numberOfColumns;

    //Calculated after delegates
    CGFloat _modifiedSpaceBetweenCells;
    CGFloat _cellWidth;
    NSUInteger _numberOfRows;
}

@property (nonatomic, readonly) UIScrollView* scrollView;

@property (nonatomic, assign) id<GridViewDelegate> delegate;
@property (nonatomic, assign) id<GridViewDataSource> dataSource;
@property (nonatomic, assign) id<GridViewDataSourceSelectionDelegate> selectionDelegate;

-(void)reloadData;

-(void)insertViewAtIndex:(NSUInteger)index;
-(void)removeViewAtIndex:(NSUInteger)index;
-(void)reloadViewAtIndex:(NSUInteger)index;
-(void)switchViewsAtFirstIndex:(NSUInteger)firstIndex secondIndex:(NSUInteger)secondIndex;

-(UIView*)viewForIndex:(NSUInteger)index;


//Only to be overloaded
-(BOOL)deleteCellAtIndex:(NSUInteger)index;

@end
