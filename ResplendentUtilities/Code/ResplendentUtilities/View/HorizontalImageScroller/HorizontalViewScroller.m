//
//  HorizontalImageScroller.m
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller.h"
#import "RUCreateDestroyViewSynthesization.h"
#import "UIView+Utility.h"
#import "RUClassOrNilUtil.h"
#import "RUConstants.h"

@interface HorizontalViewScroller ()

-(void)updateFrameForView:(UIView*)view forIndex:(NSInteger)index;
-(void)addViewToScrollViewAndUpdate:(UIView*)view;

-(void)updateScrollViewSizeFromViewsCount;
-(void)updatePageControlCountFromViewsCount;

RUCreateDestroyViewSynthesizeDeclarations(PageControl);

@end

@implementation HorizontalViewScroller

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _scrollView = [UIScrollView new];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setCanCancelContentTouches:YES];
        [_scrollView setDelaysContentTouches:YES];
        [_scrollView setAlwaysBounceHorizontal:YES];
        [_scrollView setClipsToBounds:NO];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];

        _views = [NSMutableArray array];

        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGRect scrollViewFrame = self.bounds;

    if (_pageControl)
    {
        scrollViewFrame.size.height -= CGRectGetHeight(_pageControl.frame);
        [_pageControl setFrame:CGRectSetXY(CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(CGRectGetWidth(_pageControl.frame), CGRectGetWidth(self.bounds)), CGRectGetMaxY(scrollViewFrame), _pageControl.frame)];
    }

    [_scrollView setFrame:scrollViewFrame];
}

#pragma mark - Subclass methods
-(void)didAddView:(UIView *)view
{

}

#pragma mark - Public methods
-(void)addView:(UIView*)view
{
    [self updateFrameForView:view forIndex:_views.count];

    [_views addObject:view];

    [self addViewToScrollViewAndUpdate:view];
}

-(void)insertView:(UIView*)view atIndex:(NSInteger)index
{
    if (index > _views.count)
        [NSException raise:NSRangeException format:@"%@ had index %i out of range of views %@",self,index,_views];

    [_views insertObject:view atIndex:index];

    for (int updateViewFrameIndex = index; updateViewFrameIndex < _views.count; updateViewFrameIndex++)
    {
        UIView* updateView = [_views objectAtIndex:updateViewFrameIndex];
        [self updateFrameForView:updateView forIndex:updateViewFrameIndex];
    }

    [self addViewToScrollViewAndUpdate:view];
}

-(void)empty
{
    for (UIView* view in _views)
    {
        [view removeFromSuperview];
    }

    [_views removeAllObjects];
    [_scrollView setContentSize:CGSizeZero];
}

#pragma mark - Private methods
-(void)updateFrameForView:(UIView*)view forIndex:(NSInteger)index
{
    CGFloat yCoord = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(CGRectGetHeight(view.frame), CGRectGetHeight(_scrollView.frame));
    
    CGFloat xCoordOffset = floorf(index * CGRectGetWidth(_scrollView.frame));
    CGFloat xCoord = xCoordOffset + CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(CGRectGetWidth(view.frame), CGRectGetWidth(_scrollView.frame));
    
    [view setFrame:CGRectSetXY(xCoord, yCoord, view.frame)];
}

-(void)addViewToScrollViewAndUpdate:(UIView*)view
{
    [_scrollView addSubview:view];
    
    [self updatePageControlCountFromViewsCount];
    [self updateScrollViewSizeFromViewsCount];
    [self didAddView:view];
}


-(void)updateScrollViewSizeFromViewsCount
{
    CGSize newSize = CGSizeMake(_scrollView.frame.size.width * _views.count, _scrollView.frame.size.height);
    [_scrollView setContentSize:newSize];
}

-(void)updatePageControlCountFromViewsCount
{
    if (_pageControl)
        [_pageControl setNumberOfPages:_views.count];
}

#pragma mark - Setter methods
-(void)setPageControlSize:(CGSize)pageControlSize
{
    if (pageControlSize.height && pageControlSize.width)
    {
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self createPageControl];
        [_pageControl setFrame:(CGRect){0,0,pageControlSize}];
    }
    else
    {
        [self destroyPageControl];
    }
}

#pragma mark - Getter methods
-(CGSize)pageControlSize
{
    return _pageControl.frame.size;
}

-(NSUInteger)numberOfViews
{
    return _views.count;
}

-(NSUInteger)selectedIndex
{
    return _scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
}

-(UIView *)selectedView
{
    return [_views objectAtIndex:self.selectedIndex];
}

-(UIImage *)selectedImage
{
    UIImageView* view = (UIImageView*)self.selectedView;
    if (kRUClassOrNil(view, UIImageView))
    {
        return view.image;
    }

    return nil;
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger selectedIndex = self.selectedIndex;
    [_pageControl setCurrentPage:selectedIndex];

    if (_delegate)
        [_delegate horizontalViewScroller:self didScrollToIndex:selectedIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollingDelegate)
        [_scrollingDelegate horizontalViewScroller:self didScrollToXOffset:scrollView.contentOffset.x];
}

#pragma mark - Create/Destroy Methods
-(void)createPageControl
{
    if (!_pageControl)
    {
        _pageControl = [UIPageControl new];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_pageControl];
    }
}

RUDestroyViewSynthesizeImplementation(PageControl, _pageControl);

@end
