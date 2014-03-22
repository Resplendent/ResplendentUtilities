//
//  RUColorPickerViewProtocols.h
//  Doodler
//
//  Created by Benjamin Maer on 3/2/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUColorPickerCellUtil.h"





@class RUColorPickerView;





@protocol RUColorPickerViewDelegate <NSObject>

-(RUColorPickerCellState)colorPickerView:(RUColorPickerView*)colorPickerView cellStateForIndexPath:(NSIndexPath*)indexPath;
-(void)colorPickerView:(RUColorPickerView*)colorPickerView didSelectColorAtIndexPath:(NSIndexPath*)indexPath;;

@end
