//
//  UIImageView+RUFacebookAsynchronousImageFetching.m
//  Resplendent
//
//  Created by Benjamin Maer on 7/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "UIImageView+RUFacebookAsynchronousImageFetching.h"
#import "UIImageView+RUAsynchronousImageFetching.h"





NSString* const kUIImageViewRUFacebookAsynchronousImageFetchingUrlStringFormat = @"https://graph.facebook.com/%@/picture?type=%@";





@interface UIImageView (_RUFacebookAsynchronousImageFetching)

+(NSString*)ruFacebookImageTypeStringFromEnum:(RUUIImageView_Facebook_ImageType)imageType;

@end





@implementation UIImageView (_RUFacebookAsynchronousImageFetching)

+(NSString*)ruFacebookImageTypeStringFromEnum:(RUUIImageView_Facebook_ImageType)imageType
{
	switch (imageType)
	{
		case RUUIImageView_Facebook_ImageType_Small:
			return @"small";

		case RUUIImageView_Facebook_ImageType_Normal:
			return @"normal";

		case RUUIImageView_Facebook_ImageType_Large:
			return @"large";

		case RUUIImageView_Facebook_ImageType_Square:
			return @"square";
	}
}

@end





@implementation UIImageView (RUFacebookAsynchronousImageFetching)

-(void)ruFetchImageWithFacebookId:(NSString*)facebookId imageType:(RUUIImageView_Facebook_ImageType)imageType
{
    [self ruFetchImageAsynchronouslyAtUrlString:[[self class]ruFacebookImageUrlStringForId:facebookId imageType:imageType]];
}

#pragma mark - Static Url Creation
+(NSString*)ruFacebookImageUrlStringForId:(NSString*)facebookId imageType:(RUUIImageView_Facebook_ImageType)imageType
{
    return [NSString stringWithFormat:kUIImageViewRUFacebookAsynchronousImageFetchingUrlStringFormat, facebookId, [self ruFacebookImageTypeStringFromEnum:imageType]];
}

@end
