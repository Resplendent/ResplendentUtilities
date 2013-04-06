//
//  PAHorizontalViewScroller.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/3/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller.h"

@interface PAHorizontalViewScroller : HorizontalViewScroller
{
    UIImageView* _cornerRibbon;

//    NSTimer* _cornerRibbonTimer;
}

@property (nonatomic, readonly) UIImageView* addedView;

@end
