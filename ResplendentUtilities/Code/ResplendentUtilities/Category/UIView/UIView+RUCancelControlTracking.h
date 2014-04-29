//
//  UIView+RUCancelControlTracking.h
//  Pineapple
//
//  Created by Benjamin Maer on 4/29/14.
//  Copyright (c) 2014 Pineapple. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIView (RUCancelControlTracking)

-(void)ruCancelAllControlTrackingWithEvent:(UIEvent*)event;
-(void)ruEndAllControlTrackingWithTouch:(UITouch*)touch event:(UIEvent*)event;

@end
