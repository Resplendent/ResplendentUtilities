//
//  UIImageView+RUFacebookAsynchronousImageFetching.m
//  Pineapple
//
//  Created by Benjamin Maer on 7/13/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "UIImageView+RUFacebookAsynchronousImageFetching.h"
#import "UIImageView+RUAsynchronousImageFetching.h"

NSString* const kUIImageViewRUFacebookAsynchronousImageFetchingUrlStringFormat = @"https://graph.facebook.com/%@/picture?type=large";

@implementation UIImageView (RUFacebookAsynchronousImageFetching)

-(void)ruFetchImageWithFacebookId:(NSString*)facebookId
{
    [self ruFetchImageAsynchronouslyAtUrlString:[[self class]ruFacebookImageUrlStringForId:facebookId]];
}

#pragma mark - Static Url Creation
+(NSString*)ruFacebookImageUrlStringForId:(NSString*)facebookId
{
    return [NSString stringWithFormat:kUIImageViewRUFacebookAsynchronousImageFetchingUrlStringFormat, facebookId];
}

@end
