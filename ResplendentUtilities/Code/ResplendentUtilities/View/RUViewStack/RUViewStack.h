//
//  RUViewStack.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/5/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUViewStack : UIView

-(instancetype)initWithRootView:(UIView*)rootView NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray* viewStack;
-(void)setViewStack:(NSArray *)viewStack animated:(BOOL)animated;

@property (nonatomic, readonly) UIView* currentlyVisibleView;

-(void)pushViewToStack:(UIView*)view animated:(BOOL)animated;
-(void)popTopViewFromStackAnimated:(BOOL)animated;

@end
