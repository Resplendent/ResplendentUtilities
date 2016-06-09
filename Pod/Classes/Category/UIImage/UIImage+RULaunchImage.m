//
//  UIImage+RULaunchImage.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/28/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UIImage+RULaunchImage.h"
#import <RUConditionalReturn.h>





//http://stackoverflow.com/questions/19107543/xcode-5-asset-catalog-how-to-reference-the-launchimage
@implementation UIImage (RULaunchImage)

+(UIImage*)ru_launchImageAvailableStartingAtType:(UIImage_RULaunchImage_Type)launchImageType
{
	kRUConditionalReturn_ReturnValueNil(launchImageType > UIImage_RULaunchImage_Type__last, YES);
	kRUConditionalReturn_ReturnValueNil(launchImageType < UIImage_RULaunchImage_Type__first, YES);
	
	UIImage_RULaunchImage_Type launchImageType_loop = launchImageType;
	do
	{
		UIImage* image = [self ru_launchImageWithType:launchImageType_loop];
		if (image != nil)
		{
			return image;
		}
		
		launchImageType_loop--;
	}
	while (launchImageType_loop > UIImage_RULaunchImage_Type__first);
	
	NSAssert(false, @"no image found");
	return nil;
}

+(UIImage *)ru_launchImageWithType:(UIImage_RULaunchImage_Type)launchImageType
{
	return [UIImage imageNamed:[self ru_launchImageNameWithType:launchImageType]];
}

+(NSString*)ru_launchImageNameWithType:(UIImage_RULaunchImage_Type)launchImageType
{
	NSString* const launchImageName_base = @"LaunchImage";
	
	switch (launchImageType)
	{
		case UIImage_RULaunchImage_Type_Default:
			return launchImageName_base;
			
		case UIImage_RULaunchImage_Type_Retina2x:
			return [launchImageName_base stringByAppendingString:@"-700@2x"];
			
		case UIImage_RULaunchImage_Type_Retina2x_568h:
			return [launchImageName_base stringByAppendingString:@"-700-568h@2x"];
			
		case UIImage_RULaunchImage_Type_RetinaHD_4point7:
			return [launchImageName_base stringByAppendingString:@"-800-667h@2x"];
			
		case UIImage_RULaunchImage_Type_RetinaHD_5point5:
			return [launchImageName_base stringByAppendingString:@"-800-Portrait-736h@3x"];
	}
	
	NSAssert(false, @"Unhandled");
	return nil;
}

+(UIImage_RULaunchImage_Type)ru_currentLaunchImageType
{
	CGFloat screenScale = [UIScreen mainScreen].scale;
	CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
	
	if (screenScale == 3.0f)
	{
		if (screenHeight == 736.0f)
		{
			return UIImage_RULaunchImage_Type_RetinaHD_5point5;
		}
	}
	else if (screenScale == 2.0f)
	{
		if (screenHeight == 667.0f)
		{
			return UIImage_RULaunchImage_Type_RetinaHD_4point7;
		}
		else if (screenHeight == 568.0f)
		{
			return UIImage_RULaunchImage_Type_Retina2x_568h;
		}
		else
		{
			return UIImage_RULaunchImage_Type_Retina2x;
		}
	}
	else if (screenScale == 1.0f)
	{
		return UIImage_RULaunchImage_Type_Default;
	}
	
	NSAssert(false, @"unhandled");
	return UIImage_RULaunchImage_Type_Default;
}

@end
