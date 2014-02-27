//
//  UIImageView+RUFacebookAsynchronousImageFetching.h
//  Resplendent
//
//  Created by Benjamin Maer on 7/13/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RUFacebookAsynchronousImageFetching)

-(void)ruFetchImageWithFacebookId:(NSString*)facebookId;

+(NSString*)ruFacebookImageUrlStringForId:(NSString*)facebookId;

@end
