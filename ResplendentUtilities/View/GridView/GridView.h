//
//  GridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewProtocols.h"

@interface GridView : UIView <UIScrollViewDelegate>
{
    NSMutableDictionary* _cellsDictionary;

    //Gotten from delegates
//    CGFloat _spaceBetweenCells;
    NSUInteger _numberOfCells;
//    NSUInteger _numberOfColumns;

    //Calculated after delegates
    CGFloat _modifiedSpaceBetweenCells;
    CGFloat _cellWidth;
    NSUInteger _numberOfRows;
}

@property (nonatomic, readonly) UIScrollView* scrollView;

//@property (nonatomic, assign) id<GridViewDelegate> delegate;
@property (nonatomic, assign) id<GridViewDataSource> dataSource;
@property (nonatomic, assign) id<GridViewDataSourceSelectionDelegate> selectionDelegate;

@property (nonatomic, assign) CGFloat cellSpacing;
@property (nonatomic, assign) NSUInteger numberOfColumns;

-(void)reloadData;

-(void)insertViewAtIndex:(NSUInteger)index;
-(void)removeViewAtIndex:(NSUInteger)index;
-(void)reloadViewAtIndex:(NSUInteger)index;
-(void)switchViewsAtFirstIndex:(NSUInteger)firstIndex secondIndex:(NSUInteger)secondIndex;

-(UIView*)viewForIndex:(NSUInteger)index;

//Only to be overloaded
-(BOOL)deleteCellAtIndex:(NSUInteger)index;
-(BOOL)addCellAtIndex:(NSUInteger)index;

@end
