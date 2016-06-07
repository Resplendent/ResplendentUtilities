//
//  RUColorPickerCell.h
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUColorPickerCellUtil.h"





@interface RUColorPickerCell : UICollectionViewCell
{
    UIView* _disabledShadow;
}

@property (nonatomic, assign) RUColorPickerCellState state;

@property (nonatomic, strong) UIColor* selectedBorderColor;
@property (nonatomic, strong) UIColor* disabledBorderColor;

@end
