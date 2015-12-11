//
//  UIImage+Rotation.m
//  Resplendent
//
//  Created by Benjamin Maer on 11/23/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "UIImage+RURotation.h"





@implementation UIImage (RURotation)

-(UIImage*)ru_rotatedImageToOrientation:(UIImageOrientation)orientation
{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	
	CGContextRef context=(UIGraphicsGetCurrentContext());

	switch (orientation)
	{
		case UIImageOrientationRight:
		case UIImageOrientationUp:
			CGContextRotateCTM (context, 90/180*M_PI) ;
			break;
			
		case UIImageOrientationLeft:
			CGContextRotateCTM (context, -90/180*M_PI);
			break;

		default:
			break;
	}

	[self drawAtPoint:CGPointMake(0, 0)];
	UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

@end
