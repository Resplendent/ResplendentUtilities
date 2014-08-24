//
//  WFHorizontalTitlePagingView.m
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/14/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import "RUHorizontalTitlePagingView.h"
#import "RUHorizontalTitlePagingViewCollectionViewCell.h"
#import "UIView+RUUtility.h"





NSString* const kRUHorizontalTitlePagingViewCollectionDequeCell = @"kRUHorizontalTitlePagingViewCollectionDequeCell";

typedef NS_ENUM(NSUInteger, RUHorizontalTitlePagingViewRoundingDirection) {
	RUHorizontalTitlePagingViewRoundingDirectionEven,
	RUHorizontalTitlePagingViewRoundingDirectionUp,
	RUHorizontalTitlePagingViewRoundingDirectionDown
};





@interface RUHorizontalTitlePagingView ()

@property (nonatomic, strong) UIScrollView* swipeScrollView;
@property (nonatomic, strong) UITapGestureRecognizer* swipeScrollViewTap;
@property (nonatomic, assign) NSUInteger ignoreSwipeScrollViewUpdateCounter;
@property (nonatomic, assign) BOOL scrollViewContentOffsetIsAnimating;

@property (nonatomic, strong) UICollectionViewFlowLayout* collectionViewLayout;
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, readonly) CGRect collectionViewFrame;

@property (nonatomic, readonly) CGPoint collectionViewContentOffsetFromSwipeScrollViewContentOffset;

-(NSUInteger)pageForContentOffset:(CGPoint)contentOffset contentInsetLeft:(CGFloat)contentInsetLeft withRoundingDirection:(RUHorizontalTitlePagingViewRoundingDirection)roundingDirection;

-(CGPoint)contentOffsetForPage:(NSUInteger)page;

-(void)updateCollectionViewContentOffsetFromSwipeScrollView;
-(void)updateSwipeScrollViewContentOffsetFromCollectionView;
-(void)updateSwipeScrollViewContentOffsetFromCollectionViewContentOffset:(CGPoint)collectionViewContentOffset animated:(BOOL)animated;

-(void)didTapSwipeScrollView:(UITapGestureRecognizer*)tap;

@end





@implementation RUHorizontalTitlePagingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
	{
		_swipeScrollView = [UIScrollView new];
		[self.swipeScrollView setDelegate:self];
		[self.swipeScrollView setPagingEnabled:YES];
		[self.swipeScrollView setBackgroundColor:[UIColor clearColor]];
		[self.swipeScrollView setShowsHorizontalScrollIndicator:NO];
		[self.swipeScrollView setBounces:NO];
		[self addSubview:self.swipeScrollView];

		_collectionViewLayout = [UICollectionViewFlowLayout new];
		[_collectionViewLayout setMinimumInteritemSpacing:0];
		[_collectionViewLayout setMinimumLineSpacing:0.0f];
		[_collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
		
		_collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
		[_collectionView setScrollEnabled:NO];
		[_collectionView setDataSource:self];
		[_collectionView setDelegate:self];
		[_collectionView setBackgroundColor:[UIColor clearColor]];
		[_collectionView registerClass:[RUHorizontalTitlePagingViewCollectionViewCell class] forCellWithReuseIdentifier:kRUHorizontalTitlePagingViewCollectionDequeCell];
		[_collectionView setShowsHorizontalScrollIndicator:NO];
		[_collectionView setBounces:NO];
		[self addSubview:_collectionView];
		
		[self.swipeScrollView setClipsToBounds:NO];
    }
	
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	return _swipeScrollView;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.collectionViewLayout setItemSize:self.itemSize];
	
	[self.collectionView setFrame:self.collectionViewFrame];
	
	[self.swipeScrollView setFrame:self.swipeScrollViewFrame];
	[self.swipeScrollView setContentSize:self.collectionView.contentSize];
	
	self.ignoreSwipeScrollViewUpdateCounter++;
	[self updateCollectionViewContentOffsetFromSwipeScrollView];
	self.ignoreSwipeScrollViewUpdateCounter--;
	
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, CGRectGetMinX(self.swipeScrollView.frame), 0, 0)];
}

#pragma mark - Frames
-(CGPoint)collectionViewContentOffsetFromSwipeScrollViewContentOffset
{
	CGPoint swipeScrollViewContentOffset = self.swipeScrollView.contentOffset;
	swipeScrollViewContentOffset.x -= CGRectGetMinX(self.swipeScrollView.frame);
	return swipeScrollViewContentOffset;
}

-(CGSize)itemSize
{
	return UIEdgeInsetsInsetRect(self.bounds, self.mainItemInsets).size;
}

-(CGRect)collectionViewFrame
{
	return self.bounds;
}

-(CGRect)swipeScrollViewFrame
{
	CGSize itemSize = self.itemSize;
	CGRect collectionViewFrame = self.collectionViewFrame;
	
	return (CGRect){
		.origin.x = CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(itemSize.width, CGRectGetWidth(collectionViewFrame)),
		.origin.y = 0,
		.size.width = itemSize.width,
		.size.height = CGRectGetHeight(collectionViewFrame)
	};
}

#pragma mark - Getters
-(BOOL)isDragging
{
	return self.swipeScrollView.isDragging;
}

-(BOOL)isDecelerating
{
	return self.swipeScrollView.isDecelerating;
}

#pragma mark - Setters
-(void)setTitles:(NSArray *)titles
{
	if ([self.titles isEqual:titles])
		return;
	
	_titles = titles;
	
	[_collectionView reloadData];
	[self setNeedsLayout];
}

#pragma mark - Update Content
-(void)updateCollectionViewContentOffsetFromSwipeScrollView
{
	[self setContentOffset:self.collectionViewContentOffsetFromSwipeScrollViewContentOffset animated:NO];
}

-(void)updateSwipeScrollViewContentOffsetFromCollectionView
{
	[self updateSwipeScrollViewContentOffsetFromCollectionViewContentOffset:self.collectionView.contentOffset animated:NO];
}

-(void)updateSwipeScrollViewContentOffsetFromCollectionViewContentOffset:(CGPoint)collectionViewContentOffset animated:(BOOL)animated
{
	if ((self.ignoreSwipeScrollViewUpdateCounter > 0) || self.isDragging || self.isDecelerating)
	{
		return;
	}
	
	CGPoint contentOffset = collectionViewContentOffset;
	contentOffset.x += CGRectGetMinX(self.swipeScrollView.frame);
	[self.swipeScrollView setContentOffset:contentOffset animated:animated];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	RUHorizontalTitlePagingViewCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRUHorizontalTitlePagingViewCollectionDequeCell forIndexPath:indexPath];
	
	[cell setTitle:[self.titles objectAtIndex:indexPath.row]];

	if (self.cellStylingDelegate)
	{
		if (cell.titleLabel)
		{
			if ([self.cellStylingDelegate respondsToSelector:@selector(horizontalTitlePagingView:fontForCellAtIndexPath:)])
			{
				[cell.titleLabel setFont:[self.cellStylingDelegate horizontalTitlePagingView:self fontForCellAtIndexPath:indexPath]];
			}

			if ([self.cellStylingDelegate respondsToSelector:@selector(horizontalTitlePagingView:textColorForCellAtIndexPath:)])
			{
				[cell.titleLabel setTextColor:[self.cellStylingDelegate horizontalTitlePagingView:self textColorForCellAtIndexPath:indexPath]];
			}
		}
	}

	return cell;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == self.swipeScrollView)
	{
		self.ignoreSwipeScrollViewUpdateCounter++;
		[self updateCollectionViewContentOffsetFromSwipeScrollView];
		self.ignoreSwipeScrollViewUpdateCounter--;
	}
	else
	{
		[self.scrollDelegate horizontalTitlePagingView:self didScrollToContentOffset:scrollView.contentOffset];
	}
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	
}

#pragma mark - Page
-(NSUInteger)currentPage
{
	return [self pageForContentOffset:self.collectionView.contentOffset contentInsetLeft:CGRectGetMinX(self.swipeScrollView.frame) withRoundingDirection:RUHorizontalTitlePagingViewRoundingDirectionEven];
}

-(void)setCurrentPage:(NSUInteger)currentPage
{
	[self setCurrentPage:currentPage animated:NO];
}

-(void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
	if (self.currentPage == currentPage)
		return;
	
	[self setContentOffset:[self contentOffsetForPage:currentPage] animated:animated];
}

-(NSUInteger)pageForContentOffset:(CGPoint)contentOffset contentInsetLeft:(CGFloat)contentInsetLeft withRoundingDirection:(RUHorizontalTitlePagingViewRoundingDirection)roundingDirection
{
	CGSize itemSize = self.itemSize;
	CGFloat pageFloat = (contentOffset.x + contentInsetLeft) / itemSize.width;
	
	switch (roundingDirection)
	{
		case RUHorizontalTitlePagingViewRoundingDirectionDown:
			pageFloat = floorf(pageFloat);
			break;
			
		case RUHorizontalTitlePagingViewRoundingDirectionUp:
			pageFloat = ceil(pageFloat);
			break;
			
		default:
			break;
	}
	
	return pageFloat;
}

#pragma mark - contentOffset
-(CGPoint)contentOffset
{
	return self.collectionView.contentOffset;
}

-(void)setContentOffset:(CGPoint)contentOffset
{
	[self setContentOffset:contentOffset animated:NO];
}

-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
	[self.collectionView setContentOffset:contentOffset animated:animated];
	[self updateSwipeScrollViewContentOffsetFromCollectionViewContentOffset:contentOffset animated:animated];
}

-(CGPoint)contentOffsetForPage:(NSUInteger)page
{
	return (CGPoint){
		.x = (page * self.itemSize.width) - CGRectGetMinX(self.swipeScrollView.frame),
		.y = 0
	};
}

#pragma mark - Actions
-(void)didTapSwipeScrollView:(UITapGestureRecognizer *)tap
{
	CGPoint touchPoint = [tap locationInView:self.swipeScrollView];
	
	CGPoint contentOffset = (CGPoint){
		.x = touchPoint.x - CGRectGetWidth(self.swipeScrollView.frame),
		.y = 0
	};
	
	NSUInteger page = [self pageForContentOffset:contentOffset contentInsetLeft:CGRectGetMinX(self.swipeScrollView.frame) withRoundingDirection:RUHorizontalTitlePagingViewRoundingDirectionEven];
	
	[self setCurrentPage:page animated:YES];
}

#pragma mark - enableTapToScroll
-(BOOL)enableTapToScroll
{
	return (self.swipeScrollViewTap != nil);
}

-(void)setEnableTapToScroll:(BOOL)enableTapToScroll
{
	if (self.enableTapToScroll == enableTapToScroll)
		return;

	if (enableTapToScroll)
	{
		if (!self.swipeScrollViewTap)
		{
			self.swipeScrollViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSwipeScrollView:)];
			[self.swipeScrollViewTap requireGestureRecognizerToFail:self.swipeScrollView.panGestureRecognizer];
			[self.swipeScrollView addGestureRecognizer:self.swipeScrollViewTap];
		}
	}
	else
	{
		if (self.swipeScrollViewTap)
		{
			[self.swipeScrollView removeGestureRecognizer:self.swipeScrollViewTap];
			self.swipeScrollViewTap = nil;
		}
	}
}

@end
