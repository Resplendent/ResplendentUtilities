//
//  RUHorizontalPagingView.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/26/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
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

@property (nonatomic, assign) UIEdgeInsets scrollViewFrameInsets;
@property (nonatomic, assign) CGFloat cellMinAdjustedTransformScale; //1.0f by default
@property (nonatomic, assign) CGFloat cellMinAdjustedAlpha; //1.0f by default
@property (nonatomic, assign) CGFloat cellHorizontalSeparationDistance;

@property (nonatomic, assign) CGSize pageControlSize;
@property (nonatomic, assign) BOOL pageControlOverlapsScrollView;

@property (nonatomic, assign) id<RUHorizontalPagingViewCellDelegate> cellDelegate;
@property (nonatomic, assign) id<RUHorizontalPagingViewScrollDelegate> scrollDelegate;

@property (nonatomic, readonly) Class cellClass;

@property (nonatomic, readonly) UIView* mostlyVisibleCell; //Always present if there are any photos to show

-(void)reloadContent;

-(void)addViewAtEnd;
-(void)insertViewAtPage:(NSInteger)page preserveDistanceScrolledFromRight:(BOOL)preserveDistanceScrolledFromRight;

@end
