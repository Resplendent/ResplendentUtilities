//
//  HorizontalImageScroller.h
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalViewScroller : UIView <UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    UIPageControl* _pageControl;
    NSMutableArray* _views;
}

@property (nonatomic, readonly) UIImage* selectedImage;
@property (nonatomic, readonly) NSUInteger selectedIndex;

@property (nonatomic, assign) CGSize pageControlSize;

-(void)addView:(UIView*)view;

-(void)empty;

@end
