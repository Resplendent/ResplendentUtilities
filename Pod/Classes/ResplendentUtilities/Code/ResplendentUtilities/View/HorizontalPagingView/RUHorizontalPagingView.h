//
//  RUHorizontalPagingView.h
//  Resplendent
//
//  Created by Benjamin Maer on 8/26/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUHorizontalPagingViewProtocols.h"

@interface RUHorizontalPagingView : UIView <UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    UIPageControl* _scrollViewPageControl;

    NSMutableDictionary* _visibleCells;
    NSMutableArray* _dequedCells;

    NSInteger _lastContentOffsetX;
}

@property (nonatomic, readonly) NSInteger delegateNumberOfPages;

@property (nonatomic, readonly) CGSize cellFrameSize;

@property (nonatomic, assign) UIEdgeInsets scrollViewFrameInsets;
@property (nonatomic, assign) UIEdgeInsets cellFrameInsets;
@property (nonatomic, assign) CGFloat cellMinAdjustedTransformScale; //1.0f by default
@property (nonatomic, assign) CGFloat cellMinAdjustedAlpha; //1.0f by default
@property (nonatomic, assign) CGFloat cellHorizontalSeparationDistance;

@property (nonatomic, assign) CGSize pageControlSize;
@property (nonatomic, assign) BOOL pageControlOverlapsScrollView;

@property (nonatomic, assign) id<RUHorizontalPagingViewCellDelegate> cellDelegate;
@property (nonatomic, assign) id<RUHorizontalPagingViewScrollProtocol> scrollDelegate;
@property (nonatomic, assign) id<RUHorizontalPagingViewScrollPageDelegate> scrollPageDelegate;

//Must be set, or overloaded by subclass. Trying to create a new cell with a new cellClass will result in crash.
@property (nonatomic, strong) Class cellClass;

@property (nonatomic, readonly) NSInteger closestScrolledPage;
@property (nonatomic, readonly) UIView* mostlyVisibleCell; //Always present if there are any photos to show

-(void)reloadContent;

-(void)addViewAtEnd;
-(void)insertViewAtPage:(NSInteger)page preserveDistanceScrolledFromRight:(BOOL)preserveDistanceScrolledFromRight;

//@TODO BEN let's get rid of self size
-(void)scrollToPage:(NSInteger)page selfSize:(CGSize)selfSize animated:(BOOL)animated;

// ++++++
// Only to be overloaded, not called directly

-(void)scrollViewDidSettle;

-(void)didScrollFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage;


// ------

@end
