//
//  AsynchronousUIImageRequest.h
//  Crapple
//
//  Created by Benjamin Maer on 5/3/12.
//  Copyright (c) 2012 Syracuse University. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define __AsynchronousUIImageRequest_DEBUG 1

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

@property (nonatomic, retain) NSString* url;

-(id)initAndFetchWithURL:(NSString*)anUrl withBlock:(imageErrorBlock)block;
-(id)initAndFetchWithURL:(NSString*)anUrl andCacheName:(NSString*)cacheName withBlock:(imageErrorBlock)block;

-(void)cancelFetch;

+(void)removeCacheImageByCacheName:(NSString*)cacheName;
+(void)clearCache;

@end
