//
//  UIInterfaceOrientation+RUUtil.m
//  Camerama
//
//  Created by Benjamin Maer on 11/21/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "UIInterfaceOrientation+RUUtil.h"




CGAffineTransform ru_CGAffineTransformForOrientation(UIInterfaceOrientation orientation)
{
	switch (orientation)
	{
		case UIInterfaceOrientationLandscapeLeft:
			return CGAffineTransformMakeRotation(-M_PI_2);
			
		case UIInterfaceOrientationLandscapeRight:
			return CGAffineTransformMakeRotation(M_PI_2);
			
		case UIInterfaceOrientationPortraitUpsideDown:
			return CGAffineTransformMakeRotation(M_PI);
			
		case UIInterfaceOrientationPortrait:
			return CGAffineTransformIdentity;

		case UIInterfaceOrientationUnknown:
			break;
	}
	
	NSCAssert(false, @"unhandled");
	return CGAffineTransformIdentity;
}





AVCaptureVideoOrientation ru_AVCaptureVideoOrientationForOrientation(UIInterfaceOrientation interfaceOrientation)
{
	switch (interfaceOrientation)
	{
		case UIInterfaceOrientationLandscapeLeft:
			return AVCaptureVideoOrientationLandscapeLeft;
			
		case UIInterfaceOrientationLandscapeRight:
			return AVCaptureVideoOrientationLandscapeRight;
			
		case UIInterfaceOrientationPortraitUpsideDown:
			return AVCaptureVideoOrientationPortraitUpsideDown;
			
		case UIInterfaceOrientationPortrait:
			return AVCaptureVideoOrientationPortrait;

		case UIInterfaceOrientationUnknown:
			break;
	}
	
	NSCAssert(false, @"unhandled");
	return AVCaptureVideoOrientationPortrait;
}





UIImageOrientation ru_UIImageOrientationFromInterfaceOrientation(UIInterfaceOrientation interfaceOrientation)
{
	switch (interfaceOrientation)
	{
		case UIInterfaceOrientationPortrait:
			return UIImageOrientationUp;
			
		case UIInterfaceOrientationPortraitUpsideDown:
			return UIImageOrientationDown;
			
		case UIInterfaceOrientationLandscapeRight:
			return UIImageOrientationRight;
			
		case UIInterfaceOrientationLandscapeLeft:
			return UIImageOrientationLeft;
			
		case UIInterfaceOrientationUnknown:
			break;
	}
	
	NSCAssert(false, @"unhandled");
	return UIImageOrientationUp;
}
