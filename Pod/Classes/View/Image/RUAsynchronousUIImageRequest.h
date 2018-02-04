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

#pragma mark - connection
@property (nonatomic, strong, nullable) NSURLConnection* connection;

#pragma mark - data
@property (nonatomic, strong, nullable) NSMutableData* data;

#pragma mark - cacheName
@property (nonatomic, strong, nullable) NSString* cacheName;

@property (nonatomic, strong, nullable) NSURL* url;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, assign, nullable) id<RUAsynchronousUIImageRequestDelegate> delegate;

-(nullable id)initAndFetchWithURLString:(nullable NSString*)urlString delegate:(nullable id<RUAsynchronousUIImageRequestDelegate>)delegate;
-(nullable id)initAndFetchWithURLString:(nullable NSString*)urlString cacheName:(nullable NSString*)cacheName delegate:(nullable id<RUAsynchronousUIImageRequestDelegate>)delegate;

-(nullable id)initAndFetchWithURL:(nullable NSURL*)url delegate:(nullable id<RUAsynchronousUIImageRequestDelegate>)delegate;
-(nullable id)initAndFetchWithURL:(nullable NSURL*)url cacheName:(nullable NSString*)cacheName delegate:(nullable id<RUAsynchronousUIImageRequestDelegate>)delegate;

-(void)cancelFetch;

+(void)removeCacheImageByCacheName:(nullable NSString*)cacheName;
+(void)clearCache;

+(nullable UIImage*)cachedImageForCacheName:(nullable NSString*)cacheName;

@end
