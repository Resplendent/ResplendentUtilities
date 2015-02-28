//
//  RUScrollView.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSUInteger, RUScrollViewTouchesInsideState) {
	RUScrollViewTouchesInsideStateDefault,
	RUScrollViewTouchesInsideStateIncludeSubviews,
	RUScrollViewTouchesInsideStateOnlySubviews
};





@interface RUScrollView : UIScrollView

@property (assign) BOOL disableAutoScrollToSubview;

@property (nonatomic, assign) RUScrollViewTouchesInsideState touchesInsideState;
//@property (assign) BOOL enableTouchesOutsideOfSubviews;

@end
