//
//  CMDeviceMotion+RUOrientation.m
//  Camerama
//
//  Created by Benjamin Maer on 11/21/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "CMDeviceMotion+RUOrientation.h"





@implementation CMDeviceMotion (RUOrientation)

-(UIInterfaceOrientation)ru_UIInterfaceOrientation
{
	BOOL isLandscape = fabs(self.gravity.x) > fabs(self.gravity.y);
	
	if (isLandscape)
	{
		if (self.gravity.x < 0)
		{
			return UIInterfaceOrientationLandscapeRight;
		}
		else
		{
			return UIInterfaceOrientationLandscapeLeft;
		}
	}
	else
	{
		if (self.gravity.y < 0)
		{
			return UIInterfaceOrientationPortrait;
		}
		else
		{
			return UIInterfaceOrientationPortraitUpsideDown;
		}
	}
}

-(CGAffineTransform)ru_CGAffineTransform
{
	CGFloat angle =  atan2(-self.gravity.x, -self.gravity.y );
	CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
	return transform;
}

@end
