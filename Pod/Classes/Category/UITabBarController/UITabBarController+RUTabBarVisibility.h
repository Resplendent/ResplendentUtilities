//
//  UITabBarController+RUTabBarVisibility.h
//  Shimmur
//
//  Created by Benjamin Maer on 1/13/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UITabBarController (RUTabBarVisibility)

-(void)ru_setTabBarVisibility:(BOOL)tabBarVisibility animated:(BOOL)animated animation:(void(^)(CGRect newTabBarFrame,CGFloat tableContentInsetBottomDelta))animation;

@end
