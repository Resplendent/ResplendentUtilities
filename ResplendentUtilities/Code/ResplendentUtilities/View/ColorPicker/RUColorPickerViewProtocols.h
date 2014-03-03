//
//  RUColorPickerViewProtocols.h
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUColorPickerCellUtil.h"





@protocol RUColorPickerViewDelegate <NSObject>

-(RUColorPickerCellState)colorPickerCellStateForIndexPath:(NSIndexPath*)indexPath;

@end
