//
//  GridView.h
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewProtocols.h"

typedef enum {
    GridViewTileAnimationStyleFade = 0,
    GridViewTileAnimationStyleFromCorners,
    GridViewTileAnimationStyleFromLeft
}GridViewTileAnimationStyle;

@interface GridView : UIView <UIScrollViewDelegate>
{
    NSMutableDictionary* _cellsDictionary;
    
    //Gotten from delegates
    NSUInteger _numberOfCells;
    
    //Calculated after delegates
    CGFloat _modifiedSpaceBetweenCells;
    NSUInteger _numberOfRows;
    
    CGFloat _lastScrollOffset;
    //    dispatch_queue_t _layoutTileQueue;
    
    UIActivityIndicatorView* _topSpinner;
    
    UITapGestureRecognizer* _scrollViewTap;
}

@property (nonatomic, assign) GridViewTileAnimationStyle tileAnimationStyle;

@property (nonatomic, readonly) UIScrollView* scrollView;
@property (nonatomic, readonly) CGRect scrollViewFrame;
@property (nonatomic, readonly) UIView* tileContentView;
@property (nonatomic, readonly) CGFloat cellWidth;
@property (nonatomic, readonly) CGSize scrollViewContentSize;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign) id<GridViewDataSource> dataSource;
@property (nonatomic, assign) id<GridViewDataSourceSelectionDelegate> selectionDelegate;
@property (nonatomic, assign) id<GridViewPullToLoad> pullToLoadDelegate;
@property (nonatomic, assign) id<GridViewScrollDelegate> scrollDelegate;
@property (nonatomic, assign) id<GridViewScrollDirectionDelegate> scrollDirectionDelegate;

@property (nonatomic, assign) CGFloat cellSpacing;
@property (nonatomic, assign) NSUInteger numberOfColumns;

@property (nonatomic, assign) BOOL topSpinnerVisibility;
@property (nonatomic, readonly) CGRect topSpinnerFrame;
@property (nonatomic, readonly) CGFloat topSpinnerUpperPadding;

@property (nonatomic, assign) BOOL pullToRefresh;
@property (nonatomic, assign) BOOL pullToLoadMore;
@property (nonatomic, readonly) UIActivityIndicatorView* pullToLoadMoreSpinner;

-(void)reloadData;
-(void)clearCurrentTiles;

-(void)insertViewAtIndex:(NSUInteger)index;
-(void)removeViewAtIndex:(NSUInteger)index; //Can only be called Cannot be called repeatedly
-(void)reloadViewAtIndex:(NSUInteger)index;
-(void)switchViewsAtFirstIndex:(NSUInteger)firstIndex secondIndex:(NSUInteger)secondIndex;

-(UIView*)tileForIndex:(NSUInteger)index;

-(void)stopAnimatingPullToRefresh;

//Only to be overloaded
-(BOOL)addCellAtIndex:(NSUInteger)index;

+(CGFloat)cellWidthForGridWidth:(CGFloat)gridWidth numberOfColumns:(NSUInteger)numberOfColumns cellSpacing:(CGFloat)cellSpacing leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
