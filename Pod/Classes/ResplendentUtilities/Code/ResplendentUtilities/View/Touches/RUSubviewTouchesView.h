//
//  RUSubviewTouchesView.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/5/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUSubviewTouchesView : UIView

@property (nonatomic, strong) NSArray* subviewsToAllowTouchesFrom;
-(void)addSubviewToAllowTouchesFrom:(UIView *)view;
-(void)removeSubviewToAllowTouchesFrom:(UIView *)view;

@end
