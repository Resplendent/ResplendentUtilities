//
//  UIImageView+RUFacebookAsynchronousImageFetching.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RUUIImageView_Facebook_ImageType) {
	RUUIImageView_Facebook_ImageType_Small,
	RUUIImageView_Facebook_ImageType_Normal,
	RUUIImageView_Facebook_ImageType_Large,
	RUUIImageView_Facebook_ImageType_Square,
};





@interface UIImageView (RUFacebookAsynchronousImageFetching)

-(void)ruFetchImageWithFacebookId:(NSString*)facebookId imageType:(RUUIImageView_Facebook_ImageType)imageType;

+(NSString*)ruFacebookImageUrlStringForId:(NSString*)facebookId imageType:(RUUIImageView_Facebook_ImageType)imageType;

@end
