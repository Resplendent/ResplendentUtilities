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

@property (nonatomic, readonly) NSUInteger lowestVisibleRow;
@property (nonatomic, readonly) NSUInteger currentNumberOfVisibleRows;

@property (nonatomic, readonly) BOOL needsToUpdateCells;

@property (nonatomic, assign) BOOL needsCellLayout;

-(void)updateCells;
-(void)layoutCells;
-(void)clearCurrentCells;

-(void)updateNumberOfRows;
-(void)updateCellWidth;
-(void)updateModifiedSpaceInBetweenCells;
-(void)updateScrollViewContentSize;

-(void)loadSpaceBetweenCellsFromDelegate;
-(void)loadNumberOfCellsFromDelegate;
-(void)loadNumberOfColumnsFromDelegate;

-(BOOL)deleteCellAtIndexString:(NSString*)key;
-(void)addCellAtIndex:(NSUInteger)index;

#if kGridViewUsesButtons
-(void)pressedGridViewButton:(UIButton*)button;
#endif

-(void)tappedScrollView:(UITapGestureRecognizer*)tap;

@end



@implementation GridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize needsCellLayout = _needsCellLayout;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
        
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)]];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_scrollView setFrame:self.bounds];

    [self updateCellWidth];
    [self updateScrollViewContentSize];
    [self updateCells];
}

-(void)dealloc
{
    [self clearCurrentCells];
}

#pragma mark - Getter methods
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
            if ([_cellsDictionary objectForKey:[NSString stringWithFormat:@"%i",index]])
                return YES;
        }
    }

    if (lastVisibleCell < _numberOfCells)
    {
        for (int index = lastVisibleCell + _numberOfColumns; index < lastVisibleCell; index++)
        {
            if ([_cellsDictionary objectForKey:[NSString stringWithFormat:@"%i",index]])
                return YES;
        }
    }
    
    for (int index = firstVisibleCell; index < lastVisibleCell; index++)
    {
        if (index < _numberOfCells)
        {

            if (![_cellsDictionary objectForKey:[NSString stringWithFormat:@"%i",index]])
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
#if kGridViewUsesButtons
-(void)pressedGridViewButton:(UIButton*)button
{
    if (_selectionDelegate)
    {
        UIView* view = button.superview;

        NSUInteger viewRow = floor(CGRectGetMinY(view.frame) / (_cellWidth + _modifiedSpaceBetweenCells));
        NSUInteger viewColumn = floor(CGRectGetMinX(view.frame) / (_cellWidth + _modifiedSpaceBetweenCells));

        [_selectionDelegate gridView:self didSelectViewAtIndex:viewRow * _numberOfColumns + viewColumn];
    }
}
#endif

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
        [_selectionDelegate gridView:self didSelectViewAtIndex:index];
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
        if ([_delegate respondsToSelector:@selector(gridView:prepareViewForRemoval:)])
            [_delegate gridView:self prepareViewForRemoval:view];

        [view removeFromSuperview];
        [_cellsDictionary removeObjectForKey:key];
        return YES;
    }

    return NO;
}

-(void)addCellAtIndex:(NSUInteger)index
{
    UIView* view = [_delegate gridView:self newViewForIndex:index];

    [_cellsDictionary setObject:view forKey:[NSString stringWithFormat:@"%i",index]];

#if kGridViewUsesButtons
    [view setUserInteractionEnabled:YES];
    UIButton* viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewButton setFrame:view.bounds];
    [viewButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [viewButton addTarget:self action:@selector(pressedGridViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:viewButton];
#else
    [view setUserInteractionEnabled:NO];
#endif

    [_scrollView addSubview:view];
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

-(void)layoutCells
{
    _needsCellLayout = NO;
    for (NSString* key in _cellsDictionary)
    {
        UIView* view = [_cellsDictionary objectForKey:key];

        NSUInteger index = key.integerValue;
        CGFloat width = (_cellWidth + _modifiedSpaceBetweenCells);
        CGFloat yCoord = floor(width * [self rowForIndex:index]);

        CGFloat xCoord = floor([self columnForIndex:index] * width);

        [view setFrame:CGRectMake(xCoord, yCoord, _cellWidth, _cellWidth)];
    }
}

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
            NSString* key = [NSString stringWithFormat:@"%i",index];
            UIView* view = [_cellsDictionary objectForKey:key];

            if (!view)
            {
                _needsCellLayout = YES;
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

    if (_needsCellLayout)
//    if (_needsCellLayout)
        [self layoutCells];
}

#pragma mark update methods
-(void)updateNumberOfRows
{
    _numberOfRows = floor(_numberOfCells / _numberOfColumns) + 1;
}

-(void)updateCellWidth
{
    _cellWidth = ceilf((CGRectGetWidth(_scrollView.frame) - (_numberOfColumns - 1) * _spaceBetweenCells) / _numberOfColumns);
    [self updateModifiedSpaceInBetweenCells];
}

-(void)updateModifiedSpaceInBetweenCells
{
    _modifiedSpaceBetweenCells = (CGRectGetWidth(_scrollView.frame) - (_numberOfColumns * _cellWidth)) / (_numberOfColumns - 1);
}

-(void)updateScrollViewContentSize
{
    CGFloat height = _numberOfRows * _cellWidth + (_numberOfRows - 1) * _modifiedSpaceBetweenCells;

    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame), height)];

    CGFloat maxContentOffset = MAX(_scrollView.contentSize.height - CGRectGetHeight(_scrollView.frame), 0);
    if (_scrollView.contentOffset.y > maxContentOffset)
        [_scrollView setContentOffset:CGPointMake(0, maxContentOffset)];
}

#pragma mark delegate methods
-(void)loadSpaceBetweenCellsFromDelegate
{
    if ([_dataSource respondsToSelector:@selector(gridViewSpaceBetweenCells:)])
        _spaceBetweenCells = [_dataSource gridViewSpaceBetweenCells:self];
    else
        _spaceBetweenCells = 0.0f;
}

-(void)loadNumberOfCellsFromDelegate
{
    _numberOfCells = [_dataSource gridViewNumberOfCells:self];
}

-(void)loadNumberOfColumnsFromDelegate
{
    _numberOfColumns = [_dataSource gridViewNumberOfColumns:self];
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
    _needsCellLayout = YES;
    [self setNeedsLayout];
}

-(void)reloadData
{
    [self clearCurrentCells];

    [self loadSpaceBetweenCellsFromDelegate];
    [self loadNumberOfCellsFromDelegate];
    [self loadNumberOfColumnsFromDelegate];

    [self updateNumberOfRows];
    [self setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.needsToUpdateCells)
    {
        [self updateCells];
    }
}

#pragma mark - static c methods
CG_INLINE NSString* indexStringForKey(NSUInteger index)
{
    return [NSString stringWithFormat:@"%i",index];
}

@end
