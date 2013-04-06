//
//  RUScrollView.m
//  Pineapple
//
//  Created by Benjamin Maer on 4/6/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUScrollView.h"

@implementation RUScrollView

-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    if (!_disableAutoScrollToSubview)
        [super scrollRectToVisible:rect animated:animated];
}

@end
