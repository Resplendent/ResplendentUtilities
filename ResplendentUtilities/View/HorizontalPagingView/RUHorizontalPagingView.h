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
    
    NSMutableDictionary* _visibleCells;
    NSMutableArray* _dequedCells;

    BOOL _updateContentOffsetOnLayoutSubviews;

    NSInteger _lastContentOffsetX;
}

@property (nonatomic, assign) UIEdgeInsets scrollViewFrameInsets;
@property (nonatomic, assign) CGFloat cellMinAdjustedTransformScale; //1.0f by default
@property (nonatomic, assign) CGFloat cellMinAdjustedAlpha; //1.0f by default
@property (nonatomic, assign) CGFloat cellHorizontalSeparationDistance;

@property (nonatomic, assign) id<RUHorizontalPagingViewCellDelegate> cellDelegate;
@property (nonatomic, assign) id<RUHorizontalPagingViewScrollDelegate> scrollDelegate;

@property (nonatomic, readonly) Class cellClass;

@property (nonatomic, readonly) UIView* mostlyVisibleCell; //Always present if there are any photos to show

-(void)setNeedsToUpdateContentOffsetFromAlbum;

@end
