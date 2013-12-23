//
//  RUTableView.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/8/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUTableView.h"

@implementation RUTableView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_allowTouchesOnVisibleCells)
    {
        for (UITableViewCell* cell in self.visibleCells)
        {
            if (CGRectContainsPoint(cell.frame, point))
                return YES;
        }

        return NO;
    }
    else
    {
        return [super pointInside:point withEvent:event];
    }
}

@end
