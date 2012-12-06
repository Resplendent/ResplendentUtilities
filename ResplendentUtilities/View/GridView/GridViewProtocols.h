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

-(NSUInteger)gridViewNumberOfTiles:(GridView*)gridView;

-(UIView*)gridView:(GridView*)gridView newTileForIndex:(NSUInteger)index;

@optional
-(void)gridView:(GridView*)gridView prepareTileForRemoval:(UIView*)view;

@end



@protocol GridViewDataSourceSelectionDelegate <NSObject>

-(void)gridView:(GridView*)gridView didSelectTileAtIndex:(NSUInteger)index;

@end
