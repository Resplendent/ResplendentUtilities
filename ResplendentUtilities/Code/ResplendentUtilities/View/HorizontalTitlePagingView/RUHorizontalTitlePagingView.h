//
//  WFHorizontalTitlePagingView.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/14/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUHorizontalTitlePagingViewProtocols.h"





@interface RUHorizontalTitlePagingView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) id<RUHorizontalTitlePagingViewScrollDelegate> scrollDelegate;
@property (nonatomic, assign) id<RUHorizontalTitlePagingViewCellStylingDelegate> cellStylingDelegate;

@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, assign) UIEdgeInsets mainItemInsets;
@property (nonatomic, readonly) CGSize itemSize;

@property (nonatomic, readonly) CGRect swipeScrollViewFrame;

@property (nonatomic, readonly) BOOL isDragging;
@property (nonatomic, readonly) BOOL isDecelerating;

@property (nonatomic, readonly) NSUInteger currentPage;
-(void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;

@property (nonatomic, assign) CGPoint contentOffset;
-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

@property (nonatomic, assign) BOOL enableTapToScroll;

@end
