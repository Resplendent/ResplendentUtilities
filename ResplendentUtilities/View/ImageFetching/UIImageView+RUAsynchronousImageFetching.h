//
//  UIImageView+RUAsynchronousImageFetching.h
//  Albumatic
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RUAsynchronousImageFetching)

@property (nonatomic, assign) BOOL ruLoadsUsingSpinner;
@property (nonatomic, assign) BOOL ruClearImageOnFetch;
@property (nonatomic, assign) UIActivityIndicatorViewStyle spinnerStyle;

-(void)ruCancelAsynchronousImageFetching;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url cacheName:(NSString*)cacheName;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString cacheName:(NSString*)cacheName;

@end
