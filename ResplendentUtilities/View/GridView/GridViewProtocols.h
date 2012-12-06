//
//  GridViewProtocols.h
//  Everycam
//
//  Created by Benjamin Maer on 12/5/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridView;


@protocol GridViewDataSource <NSObject>

-(NSUInteger)gridViewNumberOfCells:(GridView*)gridView;

-(UIView*)gridView:(GridView*)gridView newViewForIndex:(NSUInteger)index;

@optional
-(void)gridView:(GridView*)gridView prepareViewForRemoval:(UIView*)view;

@end



@protocol GridViewDataSourceSelectionDelegate <NSObject>

-(void)gridView:(GridView*)gridView didSelectViewAtIndex:(NSUInteger)index;

@end
