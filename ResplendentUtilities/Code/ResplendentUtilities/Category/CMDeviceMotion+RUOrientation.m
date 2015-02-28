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
	return [self ru_UIInterfaceOrientationWithGravityTolerance:0];
}

-(UIInterfaceOrientation)ru_UIInterfaceOrientationWithGravityTolerance:(double)gravityTolerance
{
	return [self.class ru_UIInterfaceOrientationFromGravityX:self.gravity.x gravityY:self.gravity.y gravityTolerance:gravityTolerance];
}

+(UIInterfaceOrientation)ru_UIInterfaceOrientationFromGravityX:(double)gravityX gravityY:(double)gravityY gravityTolerance:(double)gravityTolerance
{
	NSAssert(gravityTolerance >= 0, @"unhandled");
	gravityTolerance = fabs(gravityTolerance);
	BOOL isLandscape = fabs(gravityX) > fabs(gravityY);
	
	if (isLandscape)
	{
		if (gravityX < -gravityTolerance)
		{
			return UIInterfaceOrientationLandscapeRight;
		}
		else if (gravityX > gravityTolerance)
		{
			return UIInterfaceOrientationLandscapeLeft;
		}
	}
	else
	{
		if (gravityY < -gravityTolerance)
		{
			return UIInterfaceOrientationPortrait;
		}
		else if (gravityY > gravityTolerance)
		{
			return UIInterfaceOrientationPortraitUpsideDown;
		}
	}

	return UIInterfaceOrientationUnknown;
}

-(double)ru_gravityAngle
{
	return atan2(-self.gravity.x, -self.gravity.y);
}

-(CGAffineTransform)ru_CGAffineTransform
{
	double angle = [self ru_gravityAngle];
	CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
	return transform;
}

@end
