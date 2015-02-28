//
//  RUHorizontalPagingViewProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 8/26/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUHorizontalPagingView;





@protocol RUHorizontalPagingViewCellDelegate <NSObject>

-(NSInteger)horizontalPagingViewNumberOfCells:(RUHorizontalPagingView*)horizontalPagingView;
-(void)horizontalPagingView:(RUHorizontalPagingView*)horizontalPagingView willDisplayCell:(UIView*)cell atPage:(NSInteger)page;

@optional
-(void)horizontalPagingView:(RUHorizontalPagingView*)horizontalPagingView didCreateNewCell:(UIView*)newCell;
-(void)horizontalPagingView:(RUHorizontalPagingView*)horizontalPagingView didDequeCell:(UIView*)cell;

@end





//Never used directly, but as a protocol for other protocols to inherit from
@protocol RUHorizontalPagingViewScrollProtocol <NSObject>

-(void)horizontalPagingViewWillBeginScrolling:(RUHorizontalPagingView*)horizontalPagingView;
-(void)horizontalPagingViewDidFinishScrolling:(RUHorizontalPagingView*)horizontalPagingView;

@end





//Should be used by classes that are using as paging views who want to receive these delegate events
@protocol RUHorizontalPagingViewCellProtocol <RUHorizontalPagingViewScrollProtocol>

@end





@protocol RUHorizontalPagingViewScrollPageDelegate <NSObject>

-(void)horizontalPagingView:(RUHorizontalPagingView*)horizontalPagingView didScrollFromPage:(NSInteger)fromPage toPage:(NSInteger)toPage;

@end
