//
//  UIView+RUSnapshot.m
//  Resplendent
//
//  Created by Benjamin Maer on 5/16/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIView+RUSnapshot.h"





@implementation UIView (RUSnapshot)

-(UIImage*)ruGetSnapshotFromWindow
{
	UIView* viewToMakeImage = self.window;
	
	UIGraphicsBeginImageContextWithOptions(viewToMakeImage.bounds.size, viewToMakeImage.opaque, 0.0f);
	
	if ([viewToMakeImage respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
	{
		[viewToMakeImage drawViewHierarchyInRect:viewToMakeImage.bounds afterScreenUpdates:NO];
	}
	else
	{
		[viewToMakeImage.layer renderInContext:UIGraphicsGetCurrentContext()];
	}
	
    UIImage* snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

	return snapshotImage;
}

@end
