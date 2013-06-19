//
//  AsynchronousImageView.h
//  Crapple
//
//  Created by Ben on 5/21/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "RUAsynchronousUIImageRequestProtocols.h"

@interface AsynchronousImageView : UIImageView <RUAsynchronousUIImageRequestDelegate>
{
    RUAsynchronousUIImageRequest* _imageRequest;
    UIActivityIndicatorView*    _spinner;
}

@property (nonatomic, assign)   BOOL loadsUsingSpinner;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, assign)   NSTimeInterval fadeInDuration;

@property (nonatomic, readonly) NSURL* url;

-(void)fetchImageFromURLString:(NSString*)urlString;
-(void)fetchImageFromURLString:(NSString*)urlString withCacheName:(NSString*)cacheName;

-(void)cancelFetch;

@end
