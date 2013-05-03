//
//  UIImageView+RUAsynchronousImageFetching.h
//  Albumatic
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RUAsynchronousImageFetching)

@property (nonatomic, assign) BOOL loadsUsingSpinner;

-(void)ruCancelAsynchronousImageFetching;
-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url;
-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString;

@end
