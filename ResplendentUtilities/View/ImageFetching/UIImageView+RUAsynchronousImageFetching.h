//
//  UIImageView+RUAsynchronousImageFetching.h
//  Albumatic
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUAsynchronousImageFetchingProtocols.h"

@interface UIImageView (RUAsynchronousImageFetching)

@property (nonatomic) BOOL ruLoadsUsingSpinner;
@property (nonatomic) BOOL ruClearImageOnFetch;
@property (nonatomic) UIActivityIndicatorViewStyle spinnerStyle;

@property (nonatomic) CGFloat ruFadeInDuration;

@property (nonatomic) id<RUAsynchronousImageFetchingDelegate> ruAsynchronousImageFetchingDelegate;

-(void)ruCancelAsynchronousImageFetching;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url cacheName:(NSString*)cacheName;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString cacheName:(NSString*)cacheName;

@end
