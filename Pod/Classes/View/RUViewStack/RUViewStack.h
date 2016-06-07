//
//  RUViewStack.h
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 10/5/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUViewStackProtocols.h"





@interface RUViewStack : UIView

-(instancetype)initWithRootView:(UIView<RUViewStackProtocol>*)rootView NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray* viewStack;
-(void)setViewStack:(NSArray *)viewStack animated:(BOOL)animated;

@property (nonatomic, readonly) UIView<RUViewStackProtocol>* currentlyVisibleView;

-(void)pushViewToStack:(UIView<RUViewStackProtocol>*)view animated:(BOOL)animated;
-(void)popTopViewFromStackAnimated:(BOOL)animated;

-(void)updateCurrentlyVisibleViewFrameAnimated:(BOOL)animated;

@end
