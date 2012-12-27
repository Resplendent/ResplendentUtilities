//
//  GridView.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "GridView.h"
#import "SVPullToRefresh.h"
#import "RUConstants.h"

CGFloat const kGridViewPullToLoadMoreDefaultHeight = 50.0f;
CGFloat const kGridViewPullToLoadMorePullDistance = 30.0f;

#define kGridViewUsesButtons 0

@interface GridView ()

@property (nonatomic, readonly) NSInteger lowestVisibleRow;
@property (nonatomic, readonly) NSUInteger currentNumberOfVisibleRows;

-(void)layoutScrollViewComponents;

-(void)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex onScreen:(BOOL)onScreen animated:(BOOL)animated withDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;
//-(void)layoutTilesAnimated:(BOOL)animated;

-(void)updateTiles;

-(void)updateNumberOfRows;
-(void)updateTileWidth;
-(void)updateModifiedSpaceInBetweenTiles;
-(void)updateScrollViewContentSize;

-(void)loadNumberOfTilesFromDelegate;

-(void)deleteCellAtIndex:(NSUInteger)index stepBack:(BOOL)stepBack;
-(void)deleteTileAtIndexString:(NSString*)key stepBack:(BOOL)stepBack;

-(void)tappedScrollView:(UITapGestureRecognizer*)tap;

-(NSUInteger)rowForIndex:(NSUInteger)index;
-(NSUInteger)columnForIndex:(NSUInteger)index;

-(void)advanceAllTilesStartingAtIndex:(NSInteger)index;

@end




@implementation GridView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _scrollView = [UIScrollView new];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setDelegate:self];
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)]];
        [self addSubview:_scrollView];
    }

    return self;
}

-(void)layoutScrollViewComponents
{
    [_scrollView setFrame:self.bounds];

    [self updateTileWidth];
    [self updateScrollViewContentSize];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutScrollViewComponents];
}

-(void)dealloc
{
    [self setPullToRefresh:NO];
    [self clearCurrentTiles];
}

#pragma mark - Setter/Getter methods
-(NSUInteger)currentNumberOfVisibleRows
{
    NSUInteger numberOfVisibleRows =  ceilf(CGRectGetHeight(_scrollView.frame) / (_cellWidth + _modifiedSpaceBetweenCells));

    NSUInteger lowerVisibleRow = self.lowestVisibleRow;
    CGFloat bottofOfMinNumberOfVisibleCells = (lowerVisibleRow + numberOfVisibleRows) * (_cellWidth + _modifiedSpaceBetweenCells);
    
    if (_scrollView.contentOffset.y + CGRectGetHeight(_scrollView.frame) > bottofOfMinNumberOfVisibleCells)
        numberOfVisibleRows++;
    
    return numberOfVisibleRows;
}

-(NSInteger)lowestVisibleRow
{
    return MAX(floor(_scrollView.contentOffset.y / (_cellWidth + _modifiedSpaceBetweenCells)), 0);
}

#pragma mark Pull to load more
-(BOOL)pullToLoadMore
{
    return _pullToLoadMoreSpinner != nil;
}

-(void)setPullToLoadMore:(BOOL)pullToLoadMore
{
    if (self.pullToLoadMore == pullToLoadMore)
        return;

    if (pullToLoadMore)
    {
        _pullToLoadMoreSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_scrollView addSubview:_pullToLoadMoreSpinner];
        [self updateScrollViewContentSize];
    }
    else
    {
        [_pullToLoadMoreSpinner removeFromSuperview];
        _pullToLoadMoreSpinner = nil;
    }
}

#pragma mark Pull To Refresh
-(BOOL)pullToRefresh
{
    return _scrollView.showsPullToRefresh;
}

-(void)setPullToRefresh:(BOOL)pullToRefresh
{
    if (_scrollView)
    {
        if (pullToRefresh && !self.pullToRefresh)
        {
            //To avoid capturing self strongly in block warning
            __unsafe_unretained GridView* selfPointer = self;
            [_scrollView addPullToRefreshWithActionHandler:^{
                if (selfPointer.pullToLoadDelegate)
                {
                    [selfPointer.pullToLoadDelegate gridViewPullToReload:selfPointer];
                }
            }];
        }
        else if (!pullToRefresh && self.pullToRefresh)
        {
//            [_scrollView addPullToRefreshWithActionHandler:nil];
//            [_scrollView.pullToRefreshView stopAnimating];
            [_scrollView setShowsPullToRefresh:NO];
//            [_scrollView setPullToRefreshView:nil];
        }
    }
}

#pragma mark - Action methods
-(void)tappedScrollView:(UITapGestureRecognizer*)tap
{
    CGPoint scrollViewTouch = [tap locationInView:_scrollView];
    
    NSInteger touchColumn = floor(scrollViewTouch.x / (_cellWidth + _modifiedSpaceBetweenCells));
    if (touchColumn < 0 || touchColumn >= _numberOfColumns)
    {
        NSLog(@"touch column %i out of bounds",touchColumn);
        return;
    }
    
    NSInteger touchRow = floor(scrollViewTouch.y / (_cellWidth + _modifiedSpaceBetweenCells));
    if (touchRow < 0 || touchRow >= _numberOfRows)
    {
        NSLog(@"touch row %i out of bounds",touchRow);
        return;
    }
    
    NSUInteger index = touchRow * _numberOfColumns + touchColumn;
    
    UIView* view = [self tileForIndex:index];
    
    if (view && CGRectContainsPoint(view.bounds, [tap locationInView:view]))
    {
        [_selectionDelegate gridView:self didSelectTileAtIndex:index];
    }
}

#pragma mark - Private instance methods
-(void)advanceAllTilesStartingAtIndex:(NSInteger)index
{
    UIView* tile = [self tileForIndex:index];
    if (tile)
    {
        [self advanceAllTilesStartingAtIndex:index + 1];
        [_cellsDictionary removeObjectForKey:RUStringWithFormat(@"%i",index)];
        [_cellsDictionary setObject:tile forKey:RUStringWithFormat(@"%i",index + 1)];
        [self layoutTile:tile tileIndex:index + 1 onScreen:YES animated:YES withDelay:0 completion:nil];
    }
}

-(void)stepBackAllTilesStartingAtIndex:(NSInteger)index
{
    UIView* tile = [self tileForIndex:index];
    if (tile)
    {
        [_cellsDictionary removeObjectForKey:RUStringWithFormat(@"%i",index)];
        [_cellsDictionary setObject:tile forKey:RUStringWithFormat(@"%i",index - 1)];
        [self layoutTile:tile tileIndex:index - 1 onScreen:YES animated:YES withDelay:0 completion:nil];
        [self stepBackAllTilesStartingAtIndex:index + 1];
    }
}

-(void)deleteCellAtIndex:(NSUInteger)index stepBack:(BOOL)stepBack
{
    [self deleteTileAtIndexString:indexStringForKey(index) stepBack:stepBack];
}

-(void)deleteTileAtIndexString:(NSString*)key stepBack:(BOOL)stepBack
{
    UIView* view = [_cellsDictionary objectForKey:key];
    if (view)
    {
        if ([_dataSource respondsToSelector:@selector(gridView:prepareTileForRemoval:)])
            [_dataSource gridView:self prepareTileForRemoval:view];
        
        [self layoutTile:view tileIndex:key.integerValue onScreen:NO animated:YES withDelay:0 completion:^{
            [view removeFromSuperview];
        }];

        [_cellsDictionary removeObjectForKey:key];

        if (stepBack)
            [self stepBackAllTilesStartingAtIndex:key.integerValue + 1];
    }
}

-(BOOL)addCellAtIndex:(NSUInteger)index
{
    if ([_cellsDictionary objectForKey:indexStringForKey(index)])
    {
        return NO;
    }
    else
    {
        UIView* tile = [_dataSource gridView:self newTileForIndex:index];
        
        [_cellsDictionary setObject:tile forKey:indexStringForKey(index)];
        [tile setUserInteractionEnabled:NO];

        [_scrollView addSubview:tile];
        [self layoutTile:tile tileIndex:index onScreen:NO animated:NO withDelay:0 completion:nil];
        [self layoutTile:tile tileIndex:index onScreen:YES animated:YES withDelay:0 completion:nil];

        return YES;
    }
}

-(NSUInteger)rowForIndex:(NSUInteger)index
{
    return floor(index / _numberOfColumns);
}

-(NSUInteger)columnForIndex:(NSUInteger)index
{
    return index % _numberOfColumns;
}

#pragma mark - Layout methods
-(void)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex onScreen:(BOOL)onScreen animated:(BOOL)animated withDelay:(NSTimeInterval)delay completion:(void(^)(void))completion
{
    CGFloat width = (_cellWidth + _modifiedSpaceBetweenCells);
    CGRect newFrame = {_contentInsets.left + floor([self columnForIndex:tileIndex] * width),_contentInsets.top + floor(width * [self rowForIndex:tileIndex]),_cellWidth,_cellWidth};
    
    if (!onScreen)
    {
        switch (_tileAnimationStyle)
        {
            case GridViewTileAnimationStyleFromCorners:
                newFrame.origin = (CGPoint){-_cellWidth,(CGRectGetMinY(newFrame) < (_scrollView.contentOffset.y + (CGRectGetHeight(_scrollView.frame) / 2.0f)) ? -(_cellWidth * 2.0f) : _scrollView.contentSize.height + (_cellWidth * 2.0f)) + _cellWidth};
                break;
                
            case GridViewTileAnimationStyleFromLeft:
                newFrame.origin.x = -_cellWidth;
                break;
                
            case GridViewTileAnimationStyleFade:
                break;
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!CGRectEqualToRect(newFrame, tile.frame))
        {
            if (animated)
            {
                [UIView animateWithDuration:0.25f delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [tile setFrame:newFrame];
                } completion:^(BOOL finished) {
                    if (completion)
                        completion();
                }];
            }
            else
            {
                [tile setFrame:newFrame];
                if (completion)
                    completion();
            }
            
        }
    });
}

//-(void)layoutTilesAnimated:(BOOL)animated
//{
//    dispatch_async(_layoutTileQueue, ^{
//        NSTimeInterval delay = 0.0f;
//        for (NSString* key in _cellsDictionary)
//        {
//            UIView* tile = [_cellsDictionary objectForKey:key];
//            NSUInteger index = key.integerValue;
//            
//            if ([self layoutTile:tile tileIndex:index onScreen:YES animated:animated withDelay:delay completion:nil])
//                delay += 0.01f;
//        }
//    });
//}

#pragma mark update methods
-(void)updateTiles
{
    if (!_cellsDictionary)
    {
        _cellsDictionary = [NSMutableDictionary dictionary];
    }
    
    NSUInteger lowerVisibleRow = self.lowestVisibleRow;
    NSUInteger firstVisibleCell = lowerVisibleRow * _numberOfColumns;
    NSUInteger currentNumberOfVisibleRows = self.currentNumberOfVisibleRows;
    NSUInteger lastVisibleCell = (lowerVisibleRow + currentNumberOfVisibleRows) * _numberOfColumns;

    if (firstVisibleCell)
    {
        //Check for old cells to throw out
        for (int index = firstVisibleCell - _numberOfColumns; index < firstVisibleCell; index++)
        {
            [self deleteCellAtIndex:index stepBack:NO];
        }
    }
    
    for (int index = firstVisibleCell; index < lastVisibleCell; index++)
    {
        if (index < _numberOfCells)
        {
            [self addCellAtIndex:index];
        }
    }
    
    if (lastVisibleCell < _numberOfCells)
    {
        //Check for old cells to throw out
        for (int index = lastVisibleCell; index < _numberOfCells; index++)
        {
            [self deleteCellAtIndex:index stepBack:NO];
        }
    }
}

-(void)updateNumberOfRows
{
    _numberOfRows = ceil((double)_numberOfCells / (double)_numberOfColumns);
}

-(void)updateTileWidth
{
    CGFloat newCellWidth = [GridView cellWidthForGridWidth:CGRectGetWidth(_scrollView.frame) numberOfColumns:_numberOfColumns cellSpacing:_cellSpacing leftPadding:_contentInsets.left rightPadding:_contentInsets.right];
    if (_cellWidth != newCellWidth)
    {
        _cellWidth = newCellWidth;
        [self updateModifiedSpaceInBetweenTiles];
    }
}

-(void)updateModifiedSpaceInBetweenTiles
{
    _modifiedSpaceBetweenCells = ((CGRectGetWidth(_scrollView.frame) - _contentInsets.left - _contentInsets.right) - (_numberOfColumns * _cellWidth)) / (_numberOfColumns - 1);
}

-(void)updateScrollViewContentSize
{
    CGFloat contentHeight = MAX(_numberOfRows * _cellWidth + (_numberOfRows - 1) * _modifiedSpaceBetweenCells + _contentInsets.top + _contentInsets.bottom, CGRectGetHeight(_scrollView.frame) + 1);

    if (self.pullToLoadMore)
    {
        [_pullToLoadMoreSpinner setCenter:(CGPoint){CGRectGetWidth(_scrollView.frame) / 2.0f,contentHeight + (kGridViewPullToLoadMoreDefaultHeight / 2.0f)}];
//        NSLog(@"_pullToLoadMoreSpinner: %@",_pullToLoadMoreSpinner);
        contentHeight += kGridViewPullToLoadMoreDefaultHeight;
    }

    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame), contentHeight)];
}

#pragma mark delegate methods

-(void)loadNumberOfTilesFromDelegate
{
    _numberOfCells = [_dataSource gridViewNumberOfTiles:self];
}

#pragma mark - Public instance methods
-(void)clearCurrentTiles
{
    NSArray* keys = _cellsDictionary.allKeys;

    for (NSString* key in keys)
    {
        [self deleteTileAtIndexString:key stepBack:NO];
    }

    _numberOfCells = 0;
    _numberOfRows = 0;
}

-(UIView*)tileForIndex:(NSUInteger)index
{
    return [_cellsDictionary objectForKey:indexStringForKey(index)];
}

-(void)switchViewsAtFirstIndex:(NSUInteger)firstIndex secondIndex:(NSUInteger)secondIndex
{
    NSString* key1 = indexStringForKey(firstIndex);
    NSString* key2 = indexStringForKey(secondIndex);
    
    UIView* view1 = [_cellsDictionary objectForKey:key1];
    UIView* view2 = [_cellsDictionary objectForKey:key2];
    
    if (view2)
        [_cellsDictionary setObject:view2 forKey:key1];
    else
        [_cellsDictionary removeObjectForKey:key1];
    
    if (view1)
        [_cellsDictionary setObject:view1 forKey:key2];
    else
        [_cellsDictionary removeObjectForKey:key2];
}

-(void)insertViewAtIndex:(NSUInteger)index
{
//    NSLog(@"begin %s %i",__PRETTY_FUNCTION__,index);
    _numberOfCells++;
    [self updateNumberOfRows];
//    NSLog(@"pre cell dictionary: %@",_cellsDictionary);
    [self advanceAllTilesStartingAtIndex:index];
//    NSLog(@"advanced cell dictionary: %@",_cellsDictionary);
    [self addCellAtIndex:index];
    [self updateScrollViewContentSize];
}

-(void)removeViewAtIndex:(NSUInteger)index
{
    [self deleteCellAtIndex:index stepBack:YES];
    _numberOfCells--;
    [self updateNumberOfRows];
    [self updateScrollViewContentSize];
}

-(void)reloadViewAtIndex:(NSUInteger)index
{
    UIView* tile = [self tileForIndex:index];
    if (tile)
    {
        [_dataSource gridView:self reloadTile:tile atIndex:index];
    }
    else
    {
        NSLog(@"%s didn't have a tile at index %i, creating one instead",__PRETTY_FUNCTION__,index);
        [self addCellAtIndex:index];
    }
}

-(void)reloadData
{
    [self loadNumberOfTilesFromDelegate];
    [self updateNumberOfRows];
    [self layoutScrollViewComponents];

    [self updateTiles];
    [self layoutScrollViewComponents];

    [_pullToLoadMoreSpinner stopAnimating];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateTiles];

    if (self.pullToLoadMore && _pullToLoadDelegate && !_pullToLoadMoreSpinner.isAnimating)
    {
        if (scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height - kGridViewPullToLoadMoreDefaultHeight + kGridViewPullToLoadMorePullDistance)
        {
            [_pullToLoadMoreSpinner startAnimating];
            [_pullToLoadDelegate gridViewPullToLoadMore:self];
        }
    }

    if (_lastScrollOffset != scrollView.contentOffset.y)
    {
        if (_scrollDelegate && scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) < scrollView.contentSize.height && scrollView.contentOffset.y >= 0)
        {
            [_scrollDelegate gridView:self didScrollWithDirection:(_lastScrollOffset > scrollView.contentOffset.y ? GridViewScrollDelegateDirectionUp : GridViewScrollDelegateDirectionDown)];
            _lastScrollOffset = scrollView.contentOffset.y;
        }
        
//        if ()
    }
}

#pragma mark - static c methods
CG_INLINE NSString* indexStringForKey(NSUInteger index)
{
    return RUStringWithFormat(@"%i",index);
}

#pragma mark - Static methods
+(CGFloat)cellWidthForGridWidth:(CGFloat)gridWidth numberOfColumns:(NSUInteger)numberOfColumns cellSpacing:(CGFloat)cellSpacing leftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    return ceilf(((gridWidth - leftPadding - rightPadding) - (numberOfColumns - 1) * cellSpacing) / numberOfColumns);
}

@end
