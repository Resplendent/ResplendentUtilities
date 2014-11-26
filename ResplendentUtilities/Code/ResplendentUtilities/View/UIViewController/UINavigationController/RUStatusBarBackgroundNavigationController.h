//
//  RUStatusBarBackgroundNavigationController.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUStatusBarBackgroundNavigationController : UINavigationController

@property (nonatomic, strong) UIColor* statusBarBackgroundColor;

-(instancetype)initWithStatusBarBackgroundColor:(UIColor*)staticBarBackgroundColor;

@end
