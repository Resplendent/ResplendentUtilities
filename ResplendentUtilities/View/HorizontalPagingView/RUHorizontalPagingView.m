//
//  RUHorizontalPagingView.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUHorizontalPagingView.h"
#import "RUConstants.h"
#import "UIView+Utility.h"

@interface RUHorizontalPagingView ()

@property (nonatomic, readonly) NSInteger delegateNumberOfPages;
@property (nonatomic, readonly) NSInteger closestScrolledPage;
-(NSInteger)closestScrolledPageToContentOffsetX:(CGFloat)contentOffsetX;

@property (nonatomic, readonly) CGRect scrollViewFrame;
@property (nonatomic, readonly) CGRect visibleScrollViewFrame;

@property (nonatomic, readonly) CGSize scrollViewContentSize;
@property (nonatomic, readonly) CGSize cellSize;

@property (nonatomic, readonly) UIView* requeOrCreateCell;
@property (nonatomic, readonly) UIView* requeCell;
//Returns a new cell to be added to the scroll view
@property (nonatomic, readonly) UIView* newCell;

-(CGRect)frameForCellAtPage:(NSInteger)page;

-(void)setLastScrollViewContentOffsetX:(CGFloat)newLastContentOffsetX updateDelegate:(BOOL)updateDelegate;

-(void)scrollViewDidSettle;

-(void)updateVisibleCellsAndDequeOffscreenCells;
-(BOOL)checkToAddCellAtPage:(NSInteger)page visibleScrollViewFrame:(CGRect)visibleScrollViewFrame;
-(void)flushDequedCells;

-(CGFloat)adjustRatioForCellFrame:(CGRect)cellFrame;
-(CGFloat)roundedAdjustRatioForAdjustRatio:(CGFloat)adjustRatio;
-(CGRect)adjustCellFrameForFrame:(CGRect)cellFrame adjustRatio:(CGFloat)adjustRatio roundedAdjustRatio:(CGFloat)roundedAdjustRatio;

-(UIView *)visibleCellAtPage:(NSInteger)page;

@end

@implementation RUHorizontalPagingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setClipsToBounds:YES];

        [self setCellMinAdjustedTransformScale:1.0f];

        _visibleCells = [NSMutableDictionary dictionary];
        _dequedCells = [NSMutableArray array];
        
        _scrollView = [UIScrollView new];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setClipsToBounds:NO];
        [self addSubview:_scrollView];
    }
    
    return self;
}

#pragma mark - Getters
-(Class)cellClass
{
    return [UIView class];
}

-(NSInteger)delegateNumberOfPages
{
    return [self.cellDelegate horizontalPagingViewNumberOfCells:self];
}

-(NSInteger)closestScrolledPageToContentOffsetX:(CGFloat)contentOffsetX
{
    CGFloat numberOfPagesScrolled = contentOffsetX / CGRectGetWidth(_scrollView.frame);
    NSInteger closestPageIndex = round(numberOfPagesScrolled);
    
    if (closestPageIndex < 0)
    {
        closestPageIndex = 0;
    }
    else if (closestPageIndex >= self.delegateNumberOfPages)
    {
        closestPageIndex = self.delegateNumberOfPages - 1;
    }
    
    return closestPageIndex;
}

-(NSInteger)closestScrolledPage
{
    return [self closestScrolledPageToContentOffsetX:_scrollView.contentOffset.x];
}

#pragma mark - Setters
-(void)setLastScrollViewContentOffsetX:(CGFloat)newLastContentOffsetX updateDelegate:(BOOL)updateDelegate
{
    if (newLastContentOffsetX != _lastContentOffsetX)
    {
        NSInteger oldPage = [self closestScrolledPageToContentOffsetX:_lastContentOffsetX];
        
        _lastContentOffsetX = newLastContentOffsetX;
        
        NSInteger newPage = [self closestScrolledPageToContentOffsetX:_lastContentOffsetX];

        if (oldPage != newPage)
        {
            [self.scrollDelegate horizontalPagingView:self didScrollFromPage:oldPage toPage:newPage];
        }
    }
}

-(void)setScrollViewFrameInsets:(UIEdgeInsets)scrollViewFrameInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.scrollViewFrameInsets, scrollViewFrameInsets))
        return;
    
    _scrollViewFrameInsets = scrollViewFrameInsets;
    [self setNeedsLayout];
}

-(void)setNeedsToUpdateContentOffsetFromAlbum
{
    if (!_updateContentOffsetOnLayoutSubviews)
    {
        _updateContentOffsetOnLayoutSubviews = YES;
        [self setNeedsLayout];
    }
}

#pragma mark - Cell Getters
-(UIView *)mostlyVisibleCell
{
    return [self visibleCellAtPage:self.closestScrolledPage];
}

-(UIView*)newCell
{
    Class cellClass = self.cellClass;
    
    if (!cellClass)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must return non-nil cell class"];
    }
    
    return [cellClass new];
}

-(UIView *)requeOrCreateCell
{
    UIView* cell = self.requeCell;
    
    if (!cell)
    {
        cell = self.newCell;
    }
    
    return cell;
}

-(UIView *)requeCell
{
    if (_dequedCells.count)
    {
        UIView* dequeCell = [_dequedCells objectAtIndex:0];
        [_dequedCells removeObjectAtIndex:0];
        return dequeCell;
    }
    
    return nil;
}

-(UIView *)visibleCellAtPage:(NSInteger)page
{
    return [_visibleCells objectForKey:RUStringWithFormat(@"%i",page)];
}


#pragma mark - Frames
-(CGRect)scrollViewFrame
{
    return UIEdgeInsetsInsetRect(self.bounds, self.scrollViewFrameInsets);
}

-(CGRect)visibleScrollViewFrame
{
    CGRect visibleScrollViewFrame = (CGRect){_scrollView.contentOffset,self.bounds.size};
    visibleScrollViewFrame.origin.x -= self.scrollViewFrameInsets.left;
    return visibleScrollViewFrame;
}

-(CGSize)scrollViewContentSize
{
    CGSize photoCellSize = self.cellSize;
    photoCellSize.width *= self.delegateNumberOfPages;
    return photoCellSize;
}

-(CGSize)cellSize
{
    return (CGSize){CGRectGetWidth(self.frame) - self.scrollViewFrameInsets.left - self.scrollViewFrameInsets.right,CGRectGetHeight(self.frame) - self.scrollViewFrameInsets.top - self.scrollViewFrameInsets.bottom};
}

-(CGRect)frameForCellAtPage:(NSInteger)page
{
    CGSize photoCellSize = self.cellSize;
    return (CGRect){page * photoCellSize.width,0,photoCellSize};
}

#pragma mark - Cell Frame Helpers
-(CGFloat)adjustRatioForCellFrame:(CGRect)cellFrame
{
    CGFloat distanceFromCenter = CGRectGetMinX(cellFrame) - _scrollView.contentOffset.x;
    return distanceFromCenter / CGRectGetWidth(_scrollView.frame);
}

-(CGFloat)roundedAdjustRatioForAdjustRatio:(CGFloat)adjustRatio
{
    return MIN(fabs(adjustRatio), 1);
}

-(CGRect)adjustCellFrameForFrame:(CGRect)cellFrame adjustRatio:(CGFloat)adjustRatio roundedAdjustRatio:(CGFloat)roundedAdjustRatio
{
    CGFloat adjustedScale = 1 - ((1.0f - self.cellMinAdjustedTransformScale) * roundedAdjustRatio);
    
    CGRect adjustedCellFrame = cellFrame;
    adjustedCellFrame.size.width *= adjustedScale;
    adjustedCellFrame.size.height *= adjustedScale;
    
    adjustedCellFrame.origin.x = (CGRectGetMidX(cellFrame) - (self.cellHorizontalSeparationDistance * adjustRatio)) - (CGRectGetWidth(adjustedCellFrame) / 2.0f);
    adjustedCellFrame.origin.y = CGRectGetVerticallyAlignedYCoordForRectOnRect(adjustedCellFrame, cellFrame);
    
    return adjustedCellFrame;
}

#pragma mark - Update Content
-(void)scrollViewDidSettle
{
    [self flushDequedCells];
    [self.scrollDelegate horizontalPagingViewDidFinishScrolling:self];
}

-(void)flushDequedCells
{
    [_dequedCells removeAllObjects];
}

-(void)updateVisibleCellsAndDequeOffscreenCells
{
    if (CGRectIsEmpty(_scrollView.frame))
    {
        return;
    }
    
    CGRect visibleScrollViewFrame = self.visibleScrollViewFrame;
    NSMutableArray* pagesToDeque = [NSMutableArray array];
    
    for (NSString* page in _visibleCells)
    {
        CGRect cellFrame = [self frameForCellAtPage:page.integerValue];
        
        CGFloat adjustRatio = [self adjustRatioForCellFrame:cellFrame];
        CGFloat roundedAdjustRatio = [self roundedAdjustRatioForAdjustRatio:adjustRatio];
        CGRect adjustedCellFrame = [self adjustCellFrameForFrame:cellFrame adjustRatio:adjustRatio roundedAdjustRatio:roundedAdjustRatio];

        UIView* cell = [self visibleCellAtPage:page.integerValue];

        if (CGRectIntersectsRect(visibleScrollViewFrame, adjustedCellFrame))
        {
            [cell setFrame:adjustedCellFrame];
            [cell setAlpha:1 - (self.cellMinAdjustedAlpha * roundedAdjustRatio)];
        }
        else
        {
            [pagesToDeque addObject:page];
            [cell removeFromSuperview];
            [_dequedCells addObject:cell];
        }
    }
    
    [_visibleCells removeObjectsForKeys:pagesToDeque];
    
    NSInteger closestScrolledPage = self.closestScrolledPage;
    
    for (NSInteger page = closestScrolledPage; page < self.delegateNumberOfPages; page++)
    {
        if (![self checkToAddCellAtPage:page visibleScrollViewFrame:visibleScrollViewFrame])
        {
            break;
        }
    }
    
    for (NSInteger page = closestScrolledPage - 1; page >= 0; page--)
    {
        if (![self checkToAddCellAtPage:page visibleScrollViewFrame:visibleScrollViewFrame])
        {
            break;
        }
    }
}

-(BOOL)checkToAddCellAtPage:(NSInteger)page visibleScrollViewFrame:(CGRect)visibleScrollViewFrame
{
    if (![self visibleCellAtPage:page])
    {
        CGRect cellFrame = [self frameForCellAtPage:page];
        
        CGFloat adjustRatio = [self adjustRatioForCellFrame:cellFrame];
        
        CGFloat roundedAdjustRatio = [self roundedAdjustRatioForAdjustRatio:adjustRatio];
        CGRect adjustedCellFrame = [self adjustCellFrameForFrame:cellFrame adjustRatio:adjustRatio roundedAdjustRatio:roundedAdjustRatio];
        
        if (CGRectIntersectsRect(visibleScrollViewFrame, adjustedCellFrame))
        {
            UIView* cell = self.requeOrCreateCell;
            [cell setFrame:adjustedCellFrame];
            [_scrollView addSubview:cell];
            [_visibleCells setObject:cell forKey:RUStringWithFormat(@"%i",page)];
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setLastScrollViewContentOffsetX:scrollView.contentOffset.x updateDelegate:YES];
    [self updateVisibleCellsAndDequeOffscreenCells];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollDelegate horizontalPagingViewWillBeginScrolling:self];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidSettle];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidSettle];
}

@end
