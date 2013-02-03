//
//  AsynchronousImageView.h
//  Crapple
//
//  Created by Ben on 5/21/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsynchronousUIImageRequest;

@interface AsynchronousImageView : UIImageView
{
    AsynchronousUIImageRequest* _imageRequest;
    UIActivityIndicatorView*    _spinner;
}

@property (nonatomic, assign)   BOOL loadsUsingSpinner;
@property (nonatomic, assign)   BOOL ignoreFetchImageClear;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, assign)   NSTimeInterval fadeInDuration;
@property (nonatomic, assign)   BOOL clearOnFail;

@property (nonatomic, readonly) NSString* url;

#if EC_DEBUG
@property (nonatomic, assign)   UIView* viewToSetNeedsLayoutOnComplete;
#else
@property (nonatomic, retain)   UIView* viewToSetNeedsLayoutOnComplete;
#endif

-(void)fetchImageFromURL:(NSString*)anUrl;
-(void)fetchImageFromURL:(NSString*)anUrl withCacheName:(NSString*)cacheName;

-(void)cancelFetch;

@end
