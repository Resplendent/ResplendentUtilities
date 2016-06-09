//
//  UIView+RUCancelControlTracking.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/29/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIView+RUCancelControlTracking.h"
#import "RUClassOrNilUtil.h"





@implementation UIView (RUCancelControlTracking)

-(void)ruCancelAllControlTrackingWithEvent:(UIEvent*)event
{
	for (UIView* view in self.subviews)
	{
		UIControl* controlView = kRUClassOrNil(view, UIControl);
		if (controlView)
		{
			[controlView cancelTrackingWithEvent:event];
		}
		
		[controlView ruCancelAllControlTrackingWithEvent:event];
	}
}

-(void)ruEndAllControlTrackingWithTouch:(UITouch*)touch event:(UIEvent*)event
{
	for (UIView* view in self.subviews)
	{
		UIControl* controlView = kRUClassOrNil(view, UIControl);
		if (controlView)
		{
			[controlView endTrackingWithTouch:touch withEvent:event];
		}
		
		[controlView ruEndAllControlTrackingWithTouch:touch event:event];
	}
}

@end
