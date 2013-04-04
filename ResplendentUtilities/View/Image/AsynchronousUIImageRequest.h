//
//  AsynchronousUIImageRequest.h
//  Crapple
//
//  Created by Benjamin Maer on 5/3/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAsynchronousUIImageRequestEnableShowLastImage 0

typedef void (^imageErrorBlock)(UIImage* image, NSError* error);

@interface AsynchronousUIImageRequest : NSObject <NSURLConnectionDataDelegate>
{
    NSURLConnection*    _connection;
    NSMutableData*      _data;
    NSString*           _cacheName;
    imageErrorBlock     _block;
    
//#if __AsynchronousUIImageRequest_DEBUG
//    NSString* __urlStringDubug;
}

@property (nonatomic, readonly) NSURL* url;

-(id)initAndFetchWithURLString:(NSString*)anUrl block:(imageErrorBlock)block;
-(id)initAndFetchWithURLString:(NSString*)anUrl cacheName:(NSString*)cacheName block:(imageErrorBlock)block;

-(id)initAndFetchWithURL:(NSURL*)url block:(imageErrorBlock)block;
-(id)initAndFetchWithURL:(NSURL*)url cacheName:(NSString*)cacheName block:(imageErrorBlock)block;

-(void)cancelFetch;

+(void)removeCacheImageByCacheName:(NSString*)cacheName;
+(void)clearCache;

//DEBUGGING
#if kAsynchronousUIImageRequestEnableShowLastImage
+(void)showLastImageOnView:(UIView*)view atFrame:(CGRect)showFrame withContentMode:(UIViewContentMode)contentMode;
+(void)hideLastImage;
#endif

+(UIImage*)cachedImageForCacheName:(NSString*)cacheName;

@end
