//
//  HorizontalViewScrollerProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HorizontalViewScroller;

@protocol HorizontalViewScrollerScrollingDelegate <NSObject>

-(void)horizontalViewScroller:(HorizontalViewScroller*)horizontalViewScroller didScrollToXOffset:(CGFloat)xOffset;

@end

@protocol HorizontalViewScrollerDelegate <NSObject>

-(void)horizontalViewScroller:(HorizontalViewScroller*)horizontalViewScroller didScrollToIndex:(NSUInteger)index;

@end
