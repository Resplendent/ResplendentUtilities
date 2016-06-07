//
//  UIImage+RULaunchImage.h
//  Shimmur
//
//  Created by Benjamin Maer on 11/28/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, UIImage_RULaunchImage_Type) {
	UIImage_RULaunchImage_Type_Default,
	UIImage_RULaunchImage_Type_Retina2x,
	UIImage_RULaunchImage_Type_Retina2x_568h,
	UIImage_RULaunchImage_Type_RetinaHD_4point7,
	UIImage_RULaunchImage_Type_RetinaHD_5point5,

	UIImage_RULaunchImage_Type__first	= UIImage_RULaunchImage_Type_Default,
	UIImage_RULaunchImage_Type__last	= UIImage_RULaunchImage_Type_RetinaHD_5point5,
};





@interface UIImage (RULaunchImage)

+(UIImage*)ru_launchImageAvailableStartingAtType:(UIImage_RULaunchImage_Type)launchImageType;

+(UIImage*)ru_launchImageWithType:(UIImage_RULaunchImage_Type)launchImageType;
+(NSString*)ru_launchImageNameWithType:(UIImage_RULaunchImage_Type)launchImageType;
+(UIImage_RULaunchImage_Type)ru_currentLaunchImageType;

@end
