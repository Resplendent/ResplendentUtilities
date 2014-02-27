//
//  RUAsynchronousUIImageRequest.h
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUAsynchronousUIImageRequestProtocols.h"

@interface RUAsynchronousUIImageRequest : NSObject <NSURLConnectionDataDelegate>
{
    NSURLConnection*    _connection;
    NSMutableData*      _data;
    NSString*           _cacheName;
}

@property (nonatomic, readonly) NSURL* url;
@property (nonatomic, readonly) BOOL canceled;
@property (nonatomic, readonly, assign) id<RUAsynchronousUIImageRequestDelegate> delegate;

-(id)initAndFetchWithURLString:(NSString*)urlString delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate;
-(id)initAndFetchWithURLString:(NSString*)urlString cacheName:(NSString*)cacheName delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate;

-(id)initAndFetchWithURL:(NSURL*)url delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate;
-(id)initAndFetchWithURL:(NSURL*)url cacheName:(NSString*)cacheName delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate;

-(void)cancelFetch;

+(void)removeCacheImageByCacheName:(NSString*)cacheName;
+(void)clearCache;

+(UIImage*)cachedImageForCacheName:(NSString*)cacheName;

@end
