//
//  HorizontalImageScroller.h
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalViewScrollerProtocols.h"

@interface HorizontalViewScroller : UIView <UIScrollViewDelegate>
{
    UIPageControl* _pageControl;
    NSMutableArray* _views;
}

@property (nonatomic, readonly) UIImage* selectedImage;
@property (nonatomic, readonly) UIView* selectedView;
@property (nonatomic, readonly) UIScrollView* scrollView;
@property (nonatomic, readonly) NSUInteger selectedIndex;
@property (nonatomic, readonly) NSUInteger numberOfViews;

@property (nonatomic, assign) CGSize pageControlSize;
@property (nonatomic, assign) id<HorizontalViewScrollerDelegate> delegate;
@property (nonatomic, assign) id<HorizontalViewScrollerScrollingDelegate> scrollingDelegate;

-(void)addView:(UIView*)view;
-(void)insertView:(UIView*)view atIndex:(NSInteger)index;

-(void)empty;

//For subclassing
-(void)didAddView:(UIView*)view;

@end
