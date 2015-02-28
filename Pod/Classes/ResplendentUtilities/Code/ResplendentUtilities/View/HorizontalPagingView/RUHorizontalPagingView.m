//
//  RUHorizontalPagingView.m
//  Resplendent
//
//  Created by Benjamin Maer on 8/26/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUHorizontalPagingView.h"
#import "RUConstants.h"
#import "UIView+RUUtility.h"
#import "RUCreateDestroyViewSynthesization.h"
#import "RUDLog.h"
#import <QuartzCore/QuartzCore.h>





@interface RUHorizontalPagingView ()

@property (nonatomic, readonly) CGRect scrollViewPageControlFrame;

@property (nonatomic, readonly) CGRect scrollViewFrame;
-(CGRect)scrollViewFrameWithSelfSize:(CGSize)selfSize;
@property (nonatomic, readonly) CGRect visibleScrollViewFrame;

@property (nonatomic, readonly) CGSize scrollViewContentSize;
//@property (nonatomic, readonly) CGSize cellSize;

@property (nonatomic, readonly) UIView* requeOrCreateCell;
@property (nonatomic, readonly) UIView* requeCell;
//Returns a new cell to be added to the scroll view
@property (nonatomic, readonly) UIView* newCell;

-(NSInteger)closestScrolledPageToContentOffsetX:(CGFloat)contentOffsetX;

-(void)reloadCells;
-(void)updatePageControlCountFromViewsCount;
-(void)updatePageControlCurrentPageCount;

-(CGRect)frameForCellAtPage:(NSInteger)page;
-(CGRect)cellFrameForScrollViewFrame:(CGRect)scrollViewFrame;

-(void)setLastScrollViewContentOffsetX:(CGFloat)newLastContentOffsetX updateDelegate:(BOOL)updateDelegate;

-(void)updateVisibleCellsAndDequeOffscreenCells;
-(BOOL)checkToAddCellAtPage:(NSInteger)page visibleScrollViewFrame:(CGRect)visibleScrollViewFrame;
-(void)flushDequedCells;

-(CGFloat)adjustRatioForCellFrame:(CGRect)cellFrame;
-(CGFloat)roundedAdjustRatioForAdjustRatio:(CGFloat)adjustRatio;
-(CGFloat)adjustedScaleForRoundedAdjustRatio:(CGFloat)roundedAdjustRatio;
-(CGRect)adjustCellFrameForFrame:(CGRect)cellFrame adjustRatio:(CGFloat)adjustRatio roundedAdjustRatio:(CGFloat)roundedAdjustRatio adjustedScale:(CGFloat)adjustedScale;

-(UIView *)visibleCellAtPage:(NSInteger)page;

-(void)_didScrollFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage;

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
//        [_scrollView.panGestureRecognizer setDelaysTouchesBegan:NO];
//        [_scrollView.panGestureRecognizer setDelaysTouchesEnded:NO];
        [_scrollView setDelaysContentTouches:NO];
        [_scrollView setCanCancelContentTouches:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setClipsToBounds:NO];
        [self addSubview:_scrollView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_scrollView setFrame:self.scrollViewFrame];
    [_scrollView setContentSize:self.scrollViewContentSize];

    if (_scrollViewPageControl)
    {
        [_scrollViewPageControl setFrame:self.scrollViewPageControlFrame];
    }

    [self updateVisibleCellsAndDequeOffscreenCells];
}

#pragma mark - Getters
-(CGSize)pageControlSize
{
    return _scrollViewPageControl.frame.size;
}

//-(Class)cellClass
//{
//    return [UIView class];
//}

-(NSInteger)delegateNumberOfPages
{
    return [self.cellDelegate horizontalPagingViewNumberOfCells:self];
}

-(NSInteger)closestScrolledPageToContentOffsetX:(CGFloat)contentOffsetX
{
    CGFloat numberOfPagesScrolled = contentOffsetX / CGRectGetWidth(_scrollView.frame);
    NSInteger closestPageIndex = round(numberOfPagesScrolled);
    NSInteger upperBound = self.delegateNumberOfPages - 1;

    if (closestPageIndex > upperBound)
    {
        closestPageIndex = upperBound;
    }

    if (closestPageIndex < 0)
    {
        closestPageIndex = 0;
    }
    
    return closestPageIndex;
}

-(NSInteger)closestScrolledPage
{
    return [self closestScrolledPageToContentOffsetX:_scrollView.contentOffset.x];
}

#pragma mark - Setters
-(void)setCellClass:(Class)cellClass
{
    if (cellClass && cellClass != [UIView class] && ![cellClass isSubclassOfClass:[UIView class]])
    {
        [NSException raise:NSInvalidArgumentException format:@"cell class %@ must be of kind of class of UIView",NSStringFromClass(cellClass)];
    }
    
    _cellClass = cellClass;
}

-(void)setPageControlSize:(CGSize)pageControlSize
{
    if (pageControlSize.height && pageControlSize.width)
    {
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        if (!_scrollViewPageControl)
        {
            _scrollViewPageControl = [UIPageControl new];
            [_scrollViewPageControl setBackgroundColor:[UIColor clearColor]];
            [self addSubview:_scrollViewPageControl];
        }
        [_scrollViewPageControl setFrame:(CGRect){0,0,pageControlSize}];
    }
    else
    {
        [self destroyPageControl];
    }
}

-(void)setLastScrollViewContentOffsetX:(CGFloat)newLastContentOffsetX updateDelegate:(BOOL)updateDelegate
{
    if (newLastContentOffsetX != _lastContentOffsetX)
    {
        NSInteger oldPage = [self closestScrolledPageToContentOffsetX:_lastContentOffsetX];
        
        _lastContentOffsetX = newLastContentOffsetX;
        
        NSInteger newPage = [self closestScrolledPageToContentOffsetX:_lastContentOffsetX];

        if (oldPage != newPage)
        {
			[self _didScrollFromPage:oldPage toPage:newPage];
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

    if (cellClass != [UIView class] && ![cellClass isSubclassOfClass:[UIView class]])
    {
        [NSException raise:NSInternalInconsistencyException format:@"Cell class %@ must be kind of class UIView",NSStringFromClass(cellClass)];
    }

    return [cellClass new];
}

-(UIView *)requeOrCreateCell
{
    UIView* cell = self.requeCell;
    
    if (!cell)
    {
        cell = self.newCell;

        if ([self.cellDelegate respondsToSelector:@selector(horizontalPagingView:didCreateNewCell:)])
        {
            [self.cellDelegate horizontalPagingView:self didCreateNewCell:cell];
        }
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
    return [_visibleCells objectForKey:RUStringWithFormat(@"%li",(long)page)];
}


#pragma mark - Frames
-(CGRect)scrollViewPageControlFrame
{
    return (CGRect){CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(self.pageControlSize.width, CGRectGetWidth(self.bounds)), CGRectGetHeight(self.bounds) - self.pageControlSize.height,self.pageControlSize};
}

-(CGRect)scrollViewFrame
{
    return [self scrollViewFrameWithSelfSize:self.bounds.size];
}

-(CGRect)scrollViewFrameWithSelfSize:(CGSize)selfSize
{
    CGRect scrollViewFrame = UIEdgeInsetsInsetRect((CGRect){0,0,selfSize}, self.scrollViewFrameInsets);
    if (_scrollViewPageControl && !self.pageControlOverlapsScrollView)
    {
        scrollViewFrame.size.height -= self.pageControlSize.height;
    }
    return scrollViewFrame;
}

-(CGRect)visibleScrollViewFrame
{
    CGRect visibleScrollViewFrame = (CGRect){_scrollView.contentOffset,self.bounds.size};
    visibleScrollViewFrame.origin.x -= self.scrollViewFrameInsets.left;
    return visibleScrollViewFrame;
}

-(CGSize)scrollViewContentSize
{
    CGSize photoCellSize = self.scrollViewFrame.size;
    photoCellSize.width *= self.delegateNumberOfPages;
    return photoCellSize;
}

//-(CGSize)cellSize
//{
//    return UIEdgeInsetsInsetRect((CGRect){0,0,self.scrollViewFrame.size}, self.scrollViewFrameInsets).size;
////    return (CGSize){CGRectGetWidth(self.frame) - self.scrollViewFrameInsets.left - self.scrollViewFrameInsets.right,CGRectGetHeight(self.frame) - self.scrollViewFrameInsets.top - self.scrollViewFrameInsets.bottom};
//}

-(CGRect)cellFrameForScrollViewFrame:(CGRect)scrollViewFrame
{
    return UIEdgeInsetsInsetRect((CGRect){0,0,scrollViewFrame.size}, self.cellFrameInsets);
}

-(CGSize)cellFrameSize
{
    return [self cellFrameForScrollViewFrame:self.scrollViewFrame].size;
}

-(CGRect)frameForCellAtPage:(NSInteger)page
{
    CGRect scrollViewFrame = self.scrollViewFrame;
    CGRect cellFrame = [self cellFrameForScrollViewFrame:scrollViewFrame];
    cellFrame.origin.x += CGRectGetWidth(scrollViewFrame) * page;
    return cellFrame;
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

-(CGFloat)adjustedScaleForRoundedAdjustRatio:(CGFloat)roundedAdjustRatio
{
    return 1 - ((1.0f - self.cellMinAdjustedTransformScale) * roundedAdjustRatio);;
}

-(CGRect)adjustCellFrameForFrame:(CGRect)cellFrame adjustRatio:(CGFloat)adjustRatio roundedAdjustRatio:(CGFloat)roundedAdjustRatio adjustedScale:(CGFloat)adjustedScale
{
//    CGFloat adjustedScale = [self adjustScaleForRoundedAdjustRatio:roundedAdjustRatio];
    
    CGRect adjustedCellFrame = cellFrame;
    adjustedCellFrame.size.width *= adjustedScale;
    adjustedCellFrame.size.height *= adjustedScale;
    
    adjustedCellFrame.origin.x = (CGRectGetMidX(cellFrame) - (self.cellHorizontalSeparationDistance * adjustRatio)) - (CGRectGetWidth(adjustedCellFrame) / 2.0f);
    adjustedCellFrame.origin.y = CGRectGetVerticallyAlignedYCoordForRectOnRect(adjustedCellFrame, cellFrame);
    
    return adjustedCellFrame;
}

#pragma mark - Scrolling
-(void)scrollToPage:(NSInteger)page selfSize:(CGSize)selfSize animated:(BOOL)animated
{
    CGRect scrollViewFrameFromPageWidth = [self scrollViewFrameWithSelfSize:selfSize];
    CGFloat newContentOffsetX = page * CGRectGetWidth(scrollViewFrameFromPageWidth);

	
    [_scrollView setContentOffset:(CGPoint){newContentOffsetX,_scrollView.contentOffset.y}];
}

-(void)_didScrollFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage
{
	[self.scrollPageDelegate horizontalPagingView:self didScrollFromPage:fromPage toPage:toPage];

	[self didScrollFromPage:fromPage toPage:toPage];
}

-(void)didScrollFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage
{
	
}

#pragma mark - Update Content
-(void)updatePageControlCurrentPageCount
{
    [_scrollViewPageControl setCurrentPage:self.closestScrolledPage];
}

-(void)updatePageControlCountFromViewsCount
{
    if (_scrollViewPageControl)
    {
        [_scrollViewPageControl setNumberOfPages:self.delegateNumberOfPages];
    }
}

-(void)reloadCells
{
    [self flushDequedCells];
    for (UIView* cell in _visibleCells.allValues)
    {
        [cell removeFromSuperview];
    }
    [_visibleCells removeAllObjects];
    
    [self updateVisibleCellsAndDequeOffscreenCells];
}

-(void)reloadContent
{
    [self reloadCells];
    [self setNeedsLayout];
}

-(void)scrollViewDidSettle
{
    [self flushDequedCells];
    [self updatePageControlCurrentPageCount];
    [self.scrollDelegate horizontalPagingViewDidFinishScrolling:self];
    [self updateVisibleCellsDidFinishScrolling];
//    [self setVisibleCellsUserInteraction:YES];
}

-(void)flushDequedCells
{
    [_dequedCells removeAllObjects];
}

-(UIView*)updateAlphaAndLayerTransformOfCell:(UIView*)cell atPage:(NSInteger)page withVisibleScrollViewFrame:(CGRect)visibleScrollViewFrame allowRequeOrCreateCell:(BOOL)allowRequeOrCreateCell
{
    CGRect cellFrame = [self frameForCellAtPage:page];
    
    CGFloat adjustRatio = [self adjustRatioForCellFrame:cellFrame];
    CGFloat roundedAdjustRatio = [self roundedAdjustRatioForAdjustRatio:adjustRatio];
    CGFloat adjustedScale = [self adjustedScaleForRoundedAdjustRatio:roundedAdjustRatio];
    CGRect adjustedCellFrame = [self adjustCellFrameForFrame:cellFrame adjustRatio:adjustRatio roundedAdjustRatio:roundedAdjustRatio adjustedScale:adjustedScale];

    if (CGRectIntersectsRect(visibleScrollViewFrame, adjustedCellFrame))
    {
        if (!cell)
        {
            if (allowRequeOrCreateCell)
            {
                cell = self.requeOrCreateCell;
            }
            else
            {
                RUDLog(@"must pass non-nil cell, or allow for requeOrCreateCell");
            }
        }

        [cell.layer setTransform:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        [cell.layer setFrame:cellFrame];
        [cell layoutIfNeeded];
        [cell.layer setTransform:CATransform3DMakeScale(adjustedScale, adjustedScale, 1.0)];
//        [cell setFrame:adjustedCellFrame];
        
        [cell setAlpha:1 - (self.cellMinAdjustedAlpha * roundedAdjustRatio)];
        return cell;
    }

    return nil;
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
        UIView* cell = [self visibleCellAtPage:page.integerValue];

        if (![self updateAlphaAndLayerTransformOfCell:cell atPage:page.integerValue withVisibleScrollViewFrame:visibleScrollViewFrame allowRequeOrCreateCell:NO])
        {
            [pagesToDeque addObject:page];
            [cell removeFromSuperview];
            [_dequedCells addObject:cell];
            
            if ([self.cellDelegate respondsToSelector:@selector(horizontalPagingView:didDequeCell:)])
            {
                [self.cellDelegate horizontalPagingView:self didDequeCell:cell];
            }
        }
//        CGRect cellFrame = [self frameForCellAtPage:page.integerValue];
//        
//        CGFloat adjustRatio = [self adjustRatioForCellFrame:cellFrame];
//        CGFloat roundedAdjustRatio = [self roundedAdjustRatioForAdjustRatio:adjustRatio];
//        CGFloat adjustedScale = [self adjustedScaleForRoundedAdjustRatio:roundedAdjustRatio];
//        CGRect adjustedCellFrame = [self adjustCellFrameForFrame:cellFrame adjustRatio:adjustRatio roundedAdjustRatio:roundedAdjustRatio adjustedScale:adjustedScale];
//
//        UIView* cell = [self visibleCellAtPage:page.integerValue];
//
//        if (CGRectIntersectsRect(visibleScrollViewFrame, adjustedCellFrame))
//        {
//            [cell.layer setTransform:CATransform3DMakeScale(1.0, 1.0, 1.0)];
//            [cell.layer setFrame:cellFrame];
//            [cell.layer setTransform:CATransform3DMakeScale(adjustedScale, adjustedScale, 1.0)];
//            [cell setFrame:adjustedCellFrame];
//
//            [cell setAlpha:1 - (self.cellMinAdjustedAlpha * roundedAdjustRatio)];
//        }
//        else
//        {
//            [pagesToDeque addObject:page];
//            [cell removeFromSuperview];
//            [_dequedCells addObject:cell];
//
//            if ([self.cellDelegate respondsToSelector:@selector(horizontalPagingView:didDequeCell:)])
//            {
//                [self.cellDelegate horizontalPagingView:self didDequeCell:cell];
//            }
//        }
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

    [self updatePageControlCountFromViewsCount];
}

-(BOOL)checkToAddCellAtPage:(NSInteger)page visibleScrollViewFrame:(CGRect)visibleScrollViewFrame
{
    if (![self visibleCellAtPage:page])
    {
        UIView* cell = [self updateAlphaAndLayerTransformOfCell:nil atPage:page withVisibleScrollViewFrame:visibleScrollViewFrame allowRequeOrCreateCell:YES];
        if (cell)
        {
            [_scrollView addSubview:cell];
            [_visibleCells setObject:cell forKey:RUStringWithFormat(@"%li",(long)page)];
            [self.cellDelegate horizontalPagingView:self willDisplayCell:cell atPage:page];
            return YES;
        }
        else
        {
            return NO;
        }
    }

    return YES;
}

#pragma mark - Adding view
-(void)addViewAtEnd
{
    [self insertViewAtPage:self.delegateNumberOfPages preserveDistanceScrolledFromRight:NO];
}

-(void)insertViewAtPage:(NSInteger)page preserveDistanceScrolledFromRight:(BOOL)preserveDistanceScrolledFromRight
{
    if (preserveDistanceScrolledFromRight)
    {
        CGFloat distanceFromEnd = _scrollView.contentSize.width - _scrollView.contentOffset.x;

        [self insertViewAtPage:page preserveDistanceScrolledFromRight:NO];

        [_scrollView setContentOffset:(CGPoint){_scrollView.contentSize.width - distanceFromEnd,_scrollView.contentOffset.y}];
    }
    else
    {
        [self reloadContent];
        [self updatePageControlCountFromViewsCount];
    }
}


#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setLastScrollViewContentOffsetX:scrollView.contentOffset.x updateDelegate:YES];
    [self updateVisibleCellsAndDequeOffscreenCells];
}

-(void)setVisibleCellsUserInteraction:(BOOL)visibleCellsUserInteraction
{
    for (UIView* cell in _visibleCells.allValues)
    {
        [cell setUserInteractionEnabled:visibleCellsUserInteraction];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scrollDelegate horizontalPagingViewWillBeginScrolling:self];

    [self updateVisibleCellsWillBeginScrolling];
}

-(void)updateVisibleCellsWillBeginScrolling
{
    for (UIView<RUHorizontalPagingViewCellProtocol>* cell in _visibleCells.allValues)
    {
		if ([cell conformsToProtocol:@protocol(RUHorizontalPagingViewCellProtocol)])
		{
			[cell horizontalPagingViewWillBeginScrolling:self];
		}
    }
}

-(void)updateVisibleCellsDidFinishScrolling
{
    for (UIView<RUHorizontalPagingViewCellProtocol>* cell in _visibleCells.allValues)
    {
		if ([cell conformsToProtocol:@protocol(RUHorizontalPagingViewCellProtocol)])
		{
			[cell horizontalPagingViewDidFinishScrolling:self];
		}
    }
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

#pragma mark - Static
RUDestroyViewSynthesizeImplementation(PageControl, _scrollViewPageControl);

@end
