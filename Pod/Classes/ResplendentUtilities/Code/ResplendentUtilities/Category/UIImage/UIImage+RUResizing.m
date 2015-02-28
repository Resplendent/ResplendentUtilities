//
//  UIImage+Resizing.m
//  Resplendent
//
//  Created by Sheldon on 10/2/12.
//
//

#import "UIImage+RUResizing.h"
#import "RUConstants.h"





NSUInteger const kUIImage_RUResizing_numberOfComponentsPerARBGPixel = 4;





@implementation UIImage (RUResizing)

-(UIImage*)ru_scaleToSize:(CGSize)newSize usingMode:(UIImage_RUResizing_ResizeMode)resizeMode
{
	switch (resizeMode)
	{
		case UIImage_RUResizing_ResizeMode_AspectFit:
			return [self ru_scaleToFitSize:newSize];

		case UIImage_RUResizing_ResizeMode_AspectFill:
			return [self ru_scaleToCoverSize:newSize];

		case UIImage_RUResizing_ResizeMode_ScaleToFill:
			return [self ru_scaleToFillSize:newSize];

		default:
			break;
	}
}

-(UIImage*)ru_scaleToFitSize:(CGSize)newSize
{
	/// Keep aspect ratio
	size_t destWidth, destHeight;
	if (self.size.width > self.size.height)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	else
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	if (destWidth > newSize.width)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	if (destHeight > newSize.height)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}

	return [self ru_scaleToFillSize:(CGSize){
		.width		= destWidth,
		.height		= destHeight,
	}];
}

-(UIImage*)ru_scaleToFillSize:(CGSize)newSize
{
	size_t destWidth = (size_t)(newSize.width * self.scale);
	size_t destHeight = (size_t)(newSize.height * self.scale);
	if (self.imageOrientation == UIImageOrientationLeft
		|| self.imageOrientation == UIImageOrientationLeftMirrored
		|| self.imageOrientation == UIImageOrientationRight
		|| self.imageOrientation == UIImageOrientationRightMirrored)
	{
		size_t temp = destWidth;
		destWidth = destHeight;
		destHeight = temp;
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	/// Create an ARGB bitmap context
	CGContextRef bmContext = [self.class ru_createARGBBitmapContext:destWidth height:destHeight bytesPerRow:destWidth * kUIImage_RUResizing_numberOfComponentsPerARBGPixel withAlpha:[self ru_imageHasAlpha]];
//	CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * kUIImage_RUResizing_numberOfComponentsPerARBGPixel, NYXImageHasAlpha(self.CGImage));

	CGColorSpaceRelease(colorSpace);

	if (!bmContext)
		return nil;
	
	/// Image quality
	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
	
	/// Draw the image in the bitmap context
	
	UIGraphicsPushContext(bmContext);
	CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
	UIGraphicsPopContext();
	
	/// Create an image object from the context
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
	UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];
	
	/// Cleanup
	CGImageRelease(scaledImageRef);
	CGContextRelease(bmContext);
	
	return scaled;
}

-(UIImage*)ru_scaleToCoverSize:(CGSize)newSize
{
	size_t destWidth, destHeight;
	CGFloat widthRatio = newSize.width / self.size.width;
	CGFloat heightRatio = newSize.height / self.size.height;
	/// Keep aspect ratio
	if (heightRatio > widthRatio)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	else
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	return [self ru_scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

-(BOOL)ru_imageHasAlpha
{
	return [self.class ru_imageHasAlpha:self.CGImage];
}

#pragma mark - Static methods
+(BOOL)ru_imageHasAlpha:(CGImageRef)imageRef
{
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
	BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
	
	return hasAlpha;
}

+(CGContextRef)ru_createARGBBitmapContext:(const size_t)width height:(const size_t)height bytesPerRow:(const size_t)bytesPerRow withAlpha:(BOOL)withAlpha
{
	/// Use the generic RGB color space
	/// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
	/// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
	CGImageAlphaInfo alphaInfo = (withAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | alphaInfo);
	
	CGColorSpaceRelease(colorSpace);

	return bmContext;
}

@end
