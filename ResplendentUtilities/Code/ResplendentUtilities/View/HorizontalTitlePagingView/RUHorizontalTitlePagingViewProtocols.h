//
//  WFHorizontalTitlePagingViewProtocols.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/14/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUHorizontalTitlePagingView;





@protocol RUHorizontalTitlePagingViewScrollDelegate <NSObject>

-(void)horizontalTitlePagingView:(RUHorizontalTitlePagingView*)horizontalTitlePagingView didScrollToContentOffset:(CGPoint)contentOffset;

@end





@protocol RUHorizontalTitlePagingViewCellStylingDelegate <NSObject>

-(UIFont*)horizontalTitlePagingView:(RUHorizontalTitlePagingView*)horizontalTitlePagingView fontForCellAtIndexPath:(NSIndexPath*)indexPath;
-(UIColor*)horizontalTitlePagingView:(RUHorizontalTitlePagingView*)horizontalTitlePagingView textColorForCellAtIndexPath:(NSIndexPath*)indexPath;

@end
