//
//  UIImageView+RUAsynchronousImageFetching.h
//  Resplendent
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUAsynchronousImageFetchingProtocols.h"
#import "RUAsynchronousUIImageRequestProtocols.h"

@interface UIImageView (RUAsynchronousImageFetching) <RUAsynchronousUIImageRequestDelegate>

@property (nonatomic) BOOL ruLoadsUsingSpinner;
@property (nonatomic) BOOL ruClearImageOnFetch;
@property (nonatomic) UIActivityIndicatorViewStyle ruAsynchronousImageFetchingSpinnerStyle;

@property (nonatomic) CGFloat ruFadeInDuration;

@property (nonatomic) id<RUAsynchronousImageFetchingDelegate> ruAsynchronousImageFetchingDelegate;

@property (nonatomic, assign) BOOL ruAsynchronousImageFetchingSpinnerVisibility; //Always animating when visible

//-(void)ruAsynchronousImageFetchingShowSpinner;
//-(void)ruAsynchronousImageFetchingRemoveSpinner;

-(void)ruCancelAsynchronousImageFetching;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url cacheName:(NSString*)cacheName;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString cacheName:(NSString*)cacheName;

@end
