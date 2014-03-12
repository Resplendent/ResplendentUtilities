//
//  RUColorPickerView.h
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUColorPickerViewProtocols.h"





@interface RUColorPickerView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionViewFlowLayout* _layout;
//    UICollectionView* _collectionView;
}

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray* colors;

@property (nonatomic, readonly) UICollectionView* collectionView;

@property (nonatomic, assign) id<RUColorPickerViewDelegate> delegate;

@property (nonatomic, strong) UIColor* cellSelectedBorderColor;
@property (nonatomic, strong) UIColor* cellDisabledBorderColor;

-(UIColor*)colorForIndexPath:(NSIndexPath*)indexPath;

@end
