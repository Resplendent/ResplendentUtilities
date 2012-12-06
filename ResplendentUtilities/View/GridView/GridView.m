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

@property (nonatomic, readonly) NSUInteger lowestVisibleRow;
@property (nonatomic, readonly) NSUInteger currentNumberOfVisibleRows;

@property (nonatomic, readonly) BOOL needsToUpdateCells;

//@property (nonatomic, assign) BOOL needsCellLayout;

-(BOOL)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex animated:(BOOL)animated withDelay:(NSTimeInterval)delay;
-(void)layoutCellsAnimated:(BOOL)animated;

-(void)updateCells;//Animated:(BOOL)animated;
-(void)clearCurrentCells;

-(void)updateNumberOfRows;
-(void)updateCellWidth;
-(void)updateModifiedSpaceInBetweenCells;
-(void)updateScrollViewContentSize;

-(void)loadNumberOfCellsFromDelegate;

-(BOOL)deleteCellAtIndexString:(NSString*)key;

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

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_scrollView setFrame:self.bounds];

    [self updateCellWidth];
    [self layoutCellsAnimated:YES];
}

-(void)dealloc
{
    [self clearCurrentCells];
}

#pragma mark - Getter methods
-(CGSize)tileSize
{
    return (CGSize){_cellWidth, _cellWidth};
}

-(BOOL)needsToUpdateCells
{
    NSUInteger lowerVisibleRow = self.lowestVisibleRow;
    NSUInteger firstVisibleCell = lowerVisibleRow * _numberOfColumns;
    NSUInteger currentNumberOfVisibleRows = self.currentNumberOfVisibleRows;
    NSUInteger lastVisibleCell = (lowerVisibleRow + currentNumberOfVisibleRows) * _numberOfColumns;
    
    if (firstVisibleCell)
    {
        for (int index = firstVisibleCell - _numberOfColumns; index < firstVisibleCell; index++)
        {
            if ([_cellsDictionary objectForKey:indexStringForKey(index)])
                return YES;
        }
    }

    if (lastVisibleCell < _numberOfCells)
    {
        for (int index = lastVisibleCell + _numberOfColumns; index < lastVisibleCell; index++)
        {
            if ([_cellsDictionary objectForKey:indexStringForKey(index)])
                return YES;
        }
    }
    
    for (int index = firstVisibleCell; index < lastVisibleCell; index++)
    {
        if (index < _numberOfCells)
        {

            if (![_cellsDictionary objectForKey:indexStringForKey(index)])
            {
                return YES;
            }
        }
        else
        {
            //Blank space instead of cell
        }
    }

    return NO;
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

-(NSUInteger)lowestVisibleRow
{
    return floor(_scrollView.contentOffset.y / (_cellWidth + _modifiedSpaceBetweenCells));
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

    UIView* view = [self viewForIndex:index];

    if (view && CGRectContainsPoint(view.bounds, [tap locationInView:view]))
    {
        [_selectionDelegate gridView:self didSelectTileAtIndex:index];
    }
}

#pragma mark - Private instance methods
-(BOOL)deleteCellAtIndex:(NSUInteger)index
{
    return [self deleteCellAtIndexString:indexStringForKey(index)];
}

-(BOOL)deleteCellAtIndexString:(NSString*)key
{
    UIView* view = [_cellsDictionary objectForKey:key];
    if (view)
    {
        if ([_dataSource respondsToSelector:@selector(gridView:prepareTileForRemoval:)])
            [_dataSource gridView:self prepareTileForRemoval:view];

        [view removeFromSuperview];
        [_cellsDictionary removeObjectForKey:key];
        return YES;
    }

    return NO;
}

-(void)addCellAtIndex:(NSUInteger)index
{
    UIView* tile = [_dataSource gridView:self newTileForIndex:index];

    [_cellsDictionary setObject:tile forKey:indexStringForKey(index)];
//    [self layoutTile:tile tileIndex:-1 animated:NO withDelay:0];

    [tile setUserInteractionEnabled:NO];

    [_scrollView addSubview:tile];
}

-(void)clearCurrentCells
{
    NSArray* keys = _cellsDictionary.allKeys;

    for (NSString* key in keys)
    {
        [self deleteCellAtIndexString:key];
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
-(BOOL)layoutTile:(UIView*)tile tileIndex:(NSInteger)tileIndex animated:(BOOL)animated withDelay:(NSTimeInterval)delay
{
    CGFloat width = (_cellWidth + _modifiedSpaceBetweenCells);
    CGRect newFrame = {floor([self columnForIndex:tileIndex] * width),floor(width * [self rowForIndex:tileIndex]),self.tileSize};

    if (CGRectEqualToRect(newFrame, tile.frame))
    {
        return NO;
    }
    else
    {
        if (animated)
        {
            [tile setFrame:(CGRect){-self.tileSize.width,-self.tileSize.height,self.tileSize}];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationDelay:delay];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        }

        [tile setFrame:newFrame];
        
        if (animated)
            [UIView commitAnimations];

        return YES;
    }
}

-(void)layoutCellsAnimated:(BOOL)animated
{
    NSTimeInterval delay = 0.0f;
    for (NSString* key in _cellsDictionary)
    {
        UIView* tile = [_cellsDictionary objectForKey:key];
        NSUInteger index = key.integerValue;

        if ([self layoutTile:tile tileIndex:index animated:animated withDelay:delay])
            delay += 0.01f;
    }
}

#pragma mark update methods
-(void)updateCells
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
            [self deleteCellAtIndex:index];
        }
    }

    for (int index = firstVisibleCell; index < lastVisibleCell; index++)
    {
        if (index < _numberOfCells)
        {
            NSString* key = indexStringForKey(index);
            UIView* view = [_cellsDictionary objectForKey:key];

            if (!view)
            {
//                _needsCellLayout = YES;
                [self addCellAtIndex:index];
            }
        }
        else
        {
            //Blank space instead of cell
        }
    }

    if (lastVisibleCell < _numberOfCells)
    {
        //Check for old cells to throw out
        for (int index = lastVisibleCell + _numberOfColumns; index < lastVisibleCell; index++)
        {
            [self deleteCellAtIndex:index];
        }
    }
}

-(void)updateNumberOfRows
{
    _numberOfRows = floor(_numberOfCells / _numberOfColumns) + 1;
}

-(void)updateCellWidth
{
    CGFloat newCellWidth = ceilf((CGRectGetWidth(_scrollView.frame) - (_numberOfColumns - 1) * _cellSpacing) / _numberOfColumns);
    if (_cellWidth != newCellWidth)
    {
        _cellWidth = newCellWidth;
        [self updateModifiedSpaceInBetweenCells];

        [self updateScrollViewContentSize];
    }
}

-(void)updateModifiedSpaceInBetweenCells
{
    _modifiedSpaceBetweenCells = (CGRectGetWidth(_scrollView.frame) - (_numberOfColumns * _cellWidth)) / (_numberOfColumns - 1);
}

-(void)updateScrollViewContentSize
{
    CGFloat height = _numberOfRows * _cellWidth + (_numberOfRows - 1) * _modifiedSpaceBetweenCells;

    if (_scrollView.contentSize.height != height)
    {
        [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame), height)];
        
        CGFloat maxContentOffset = MAX(_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame), 0);
        if (_scrollView.contentOffset.y > maxContentOffset)
            [_scrollView setContentOffset:CGPointMake(0, maxContentOffset)];
    }
}

#pragma mark delegate methods

-(void)loadNumberOfCellsFromDelegate
{
    _numberOfCells = [_dataSource gridViewNumberOfTiles:self];
}

#pragma mark - Public instance methods
-(UIView*)viewForIndex:(NSUInteger)index
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
    [self deleteCellAtIndex:index];
    [self addCellAtIndex:index];
//    _needsCellLayout = YES;
    [self setNeedsLayout];
}

-(void)reloadData
{
    [self clearCurrentCells];

    [self loadNumberOfCellsFromDelegate];
    [self updateNumberOfRows];
    [self updateCells];
    [self setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.needsToUpdateCells)
    {
        [self setNeedsLayout];
        [self updateCells];
    }
}

#pragma mark - static c methods
CG_INLINE NSString* indexStringForKey(NSUInteger index)
{
    return [NSString stringWithFormat:@"%i",index];
}

@end
