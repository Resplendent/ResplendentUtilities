//
//  UIImage+RUImageFromColor.m
//  Nifti
//
//  Created by Benjamin Maer on 1/3/15.
//  Copyright (c) 2015 Nifti. All rights reserved.
//

#import "UIImage+RUImageFromColor.h"





@implementation UIImage (RUImageFromColor)

+(UIImage*)ru_imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if (radius)
	{
		// Begin a new image that will be the new image with the rounded corners
		// (here with the size of an UIImageView)
		UIGraphicsBeginImageContext(size);
		
		// Add a clip before drawing anything, in the shape of an rounded rect
		[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
		// Draw your image
		[image drawInRect:rect];
		
		// Get the image, here setting the UIImageView image
		image = UIGraphicsGetImageFromCurrentImageContext();
		
		// Lets forget about that we were drawing
		UIGraphicsEndImageContext();
	}
	
	return image;
}

//+(UIImage*)ru_imageFromColor:(UIColor *)color forSize:(CGSize)size
//{
//	return [self ru_im]
//	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//	UIGraphicsBeginImageContext(rect.size);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	
//	CGContextSetFillColorWithColor(context, [color CGColor]);
//	CGContextFillRect(context, rect);
//	
//	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return image;
//}

@end
