//
//  GridView.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "GridView.h"

#define kGridViewUsesButtons 0

@interface GridView ()

@property (nonatomic, readonly) CGSize tileSize;

@property (nonatomic, readonly) NSInteger lowestVisibleRow;
@property (nonatomic, readonly) NSUInteger currentNumberOfVisibleRows;

-(void)layoutScrollViewComponents;

-(BOOL)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex onScreen:(BOOL)onScreen animated:(BOOL)animated withDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;
-(void)layoutTilesAnimated:(BOOL)animated;

-(BOOL)updateTiles;//Animated:(BOOL)animated;
-(void)clearCurrentTiles;

-(void)updateNumberOfRows;
-(void)updateTileWidth;
-(void)updateModifiedSpaceInBetweenTiles;
-(void)updateScrollViewContentSize;

-(void)loadNumberOfTilesFromDelegate;

-(BOOL)deleteTilesAtIndexString:(NSString*)key;

-(void)tappedScrollView:(UITapGestureRecognizer*)tap;

@end



@implementation GridView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _scrollView = [UIScrollView new];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
        
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)]];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
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
    [self layoutTilesAnimated:YES];
}

-(void)dealloc
{
    [self clearCurrentTiles];
}

#pragma mark - Getter methods
-(CGSize)tileSize
{
    return (CGSize){_cellWidth, _cellWidth};
}

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
-(BOOL)deleteCellAtIndex:(NSUInteger)index
{
    return [self deleteTilesAtIndexString:indexStringForKey(index)];
}

-(BOOL)deleteTilesAtIndexString:(NSString*)key
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
        
        return YES;
    }
    
    return NO;
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

        return YES;
    }
}

-(void)clearCurrentTiles
{
    NSArray* keys = _cellsDictionary.allKeys;
    
    for (NSString* key in keys)
    {
        [self deleteTilesAtIndexString:key];
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
-(BOOL)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex onScreen:(BOOL)onScreen animated:(BOOL)animated withDelay:(NSTimeInterval)delay completion:(void(^)(void))completion
{
    CGFloat width = (_cellWidth + _modifiedSpaceBetweenCells);
    CGRect newFrame = {floor([self columnForIndex:tileIndex] * width),floor(width * [self rowForIndex:tileIndex]),self.tileSize};
    
    if (!onScreen)
    {
        CGFloat upperBound = _scrollView.contentOffset.y;
        CGFloat lowerBound = upperBound + CGRectGetHeight(_scrollView.frame);
        
        CGFloat yCoord = (CGRectGetMinY(newFrame) < (upperBound + lowerBound) / 2.0f ? -(_cellWidth * 2.0f) : _scrollView.contentSize.height + (_cellWidth * 2.0f));
        newFrame.origin = (CGPoint){-_cellWidth,yCoord + _cellWidth};
    }
    
    if (CGRectEqualToRect(newFrame, tile.frame))
    {
        return NO;
    }
    else
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
        
        
        return YES;
    }
}

-(void)layoutTilesAnimated:(BOOL)animated
{
    NSTimeInterval delay = 0.0f;
    for (NSString* key in _cellsDictionary)
    {
        UIView* tile = [_cellsDictionary objectForKey:key];
        NSUInteger index = key.integerValue;
        
        if ([self layoutTile:tile tileIndex:index onScreen:YES animated:animated withDelay:delay completion:nil])
            delay += 0.01f;
    }
}

#pragma mark update methods
-(BOOL)updateTiles
{
    if (!_cellsDictionary)
    {
        _cellsDictionary = [NSMutableDictionary dictionary];
    }
    
    NSUInteger lowerVisibleRow = self.lowestVisibleRow;
    NSUInteger firstVisibleCell = lowerVisibleRow * _numberOfColumns;
    NSUInteger currentNumberOfVisibleRows = self.currentNumberOfVisibleRows;
    NSUInteger lastVisibleCell = (lowerVisibleRow + currentNumberOfVisibleRows) * _numberOfColumns;
    BOOL update = NO;
    
    //    NSLog(@"self.lowestVisibleRow: %i",self.lowestVisibleRow);
    //    NSLog(@"lowerVisibleRow: %i",lowerVisibleRow);
    //    NSLog(@"_numberOfColumns: %i",_numberOfColumns);
    //    NSLog(@"firstVisibleCell: %i",firstVisibleCell);
    //    NSLog(@"currentNumberOfVisibleRows: %i",currentNumberOfVisibleRows);
    //    NSLog(@"lastVisibleCell: %i",lastVisibleCell);
    
    if (firstVisibleCell)
    {
        //Check for old cells to throw out
        for (int index = firstVisibleCell - _numberOfColumns; index < firstVisibleCell; index++)
        {
            if ([self deleteCellAtIndex:index])
                update = YES;
        }
    }
    
    for (int index = firstVisibleCell; index < lastVisibleCell; index++)
    {
        if (index < _numberOfCells)
        {
            if ([self addCellAtIndex:index])
                update = YES;
        }
    }
    
    //    NSLog(@"_numberOfCells: %i",_numberOfCells);
    if (lastVisibleCell < _numberOfCells)
    {
        //Check for old cells to throw out
        for (int index = lastVisibleCell; index < _numberOfCells; index++)
        {
            if ([self deleteCellAtIndex:index])
                update = YES;
        }
    }
    
    return update;
}

-(void)updateNumberOfRows
{
    _numberOfRows = ceil(_numberOfCells / _numberOfColumns);
}

-(void)updateTileWidth
{
    CGFloat newCellWidth = [GridView cellWidthForGridWidth:CGRectGetWidth(_scrollView.frame) numberOfColumns:_numberOfColumns cellSpacing:_cellSpacing];
    if (_cellWidth != newCellWidth)
    {
        _cellWidth = newCellWidth;
        [self updateModifiedSpaceInBetweenTiles];
    }
}

-(void)updateModifiedSpaceInBetweenTiles
{
    _modifiedSpaceBetweenCells = (CGRectGetWidth(_scrollView.frame) - (_numberOfColumns * _cellWidth)) / (_numberOfColumns - 1);
}

-(void)updateScrollViewContentSize
{
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame), MAX(_numberOfRows * _cellWidth + (_numberOfRows - 1) * _modifiedSpaceBetweenCells, CGRectGetHeight(_scrollView.frame) + 1))];
}

#pragma mark delegate methods

-(void)loadNumberOfTilesFromDelegate
{
    _numberOfCells = [_dataSource gridViewNumberOfTiles:self];
}

#pragma mark - Public instance methods
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

-(void)advanceCellAtIndex:(int)index
{
    for (int i = _numberOfCells - 1; i >= index; i--)
    {
        NSString* key = indexStringForKey(i);
        
        UIView* view = [_cellsDictionary objectForKey:key];
        if (view)
        {
            NSString* nextKey = indexStringForKey(i + 1);
            [_cellsDictionary setObject:view forKey:nextKey];
            [_cellsDictionary removeObjectForKey:key];
        }
    }
}

-(void)insertViewAtIndex:(NSUInteger)index
{
    _numberOfCells++;
    [self updateNumberOfRows];
    [self advanceCellAtIndex:index];
    if ([self addCellAtIndex:index])
        [self setNeedsLayout];
}

-(void)removeViewAtIndex:(NSUInteger)index
{
    if ([self deleteCellAtIndex:index])
    {
        _numberOfCells--;
        [self updateNumberOfRows];
        [self setNeedsLayout];
    }
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
        if ([self addCellAtIndex:index])
            [self setNeedsLayout];
    }
}

-(void)reloadData
{
    [self clearCurrentTiles];
    
    [self loadNumberOfTilesFromDelegate];
    [self updateNumberOfRows];
    [self layoutScrollViewComponents];

    if ([self updateTiles])
        [self setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self updateTiles])
        [self layoutTilesAnimated:YES];
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self layoutTilesAnimated:YES];
//}

#pragma mark - static c methods
CG_INLINE NSString* indexStringForKey(NSUInteger index)
{
    return [NSString stringWithFormat:@"%i",index];
}

#pragma mark - Static methods
+(CGFloat)cellWidthForGridWidth:(CGFloat)gridWidth numberOfColumns:(NSUInteger)numberOfColumns cellSpacing:(CGFloat)cellSpacing
{
    return ceilf((gridWidth - (numberOfColumns - 1) * cellSpacing) / numberOfColumns);
}

@end
