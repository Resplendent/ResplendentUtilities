//
//  RUAsynchronousUIImageRequest.m
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RUAsynchronousUIImageRequest.h"

#import "RUConstants.h"

static NSMutableDictionary* fetchedImages;

@interface RUAsynchronousUIImageRequest ()

-(void)cancelFetchClearDelegate:(BOOL)clearDelegate;

@end

@implementation RUAsynchronousUIImageRequest

+(void)initialize
{
    if (self == [RUAsynchronousUIImageRequest class])
    {
        fetchedImages = [NSMutableDictionary dictionary];
    }
}

-(id)initAndFetchWithURLString:(NSString*)urlString delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate
{
    return [self initAndFetchWithURLString:urlString cacheName:urlString delegate:delegate];
}

-(id)initAndFetchWithURLString:(NSString*)urlString cacheName:(NSString *)cacheName delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate
{
    return [self initAndFetchWithURL:[NSURL URLWithString:urlString] cacheName:cacheName delegate:delegate];
}

-(id)initAndFetchWithURL:(NSURL*)url delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate
{
    return [self initAndFetchWithURL:url cacheName:url.absoluteString delegate:delegate];
}

-(id)initAndFetchWithURL:(NSURL*)url cacheName:(NSString*)cacheName delegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate
{
    if (!url)
        [NSException raise:NSInvalidArgumentException format:@"Can't fetch image without a url"];
    
    if (self = [self init])
    {
        _cacheName = (cacheName ? cacheName : url.absoluteString);
        _url = url;
        [self fetchImageWithDelegate:delegate];
    }
    
    return self;
}

-(void)dealloc
{
    [self cancelFetch];
}

#pragma mark - Private methods
-(void)ruAsynchronousUIImageFinishedWithImage:(UIImage*)image error:(NSError*)error
{
    if (!self.canceled)
    {
        if (error)
        {
            [self.delegate asynchronousUIImageRequest:self didFailLoadingWithError:error];
        }
        else
        {
            [self.delegate asynchronousUIImageRequest:self didFinishLoadingWithImage:image];
        }
    }
}

#pragma mark - Private methods
-(void)fetchImageWithDelegate:(id<RUAsynchronousUIImageRequestDelegate>)delegate
{
    [self cancelFetch];
    _delegate = delegate;
    _canceled = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelFetchClearDelegate:NO];
        _canceled = NO;
        
        UIImage* cachedImage = [RUAsynchronousUIImageRequest cachedImageForCacheName:_cacheName];
        
        if (cachedImage)
        {
#if kAsynchronousUIImageRequestEnableShowLastImage
            if (showLastImageView)
                [showLastImageView setImage:cachedImage];
#endif
            [self ruAsynchronousUIImageFinishedWithImage:cachedImage error:nil];
        }
        else
        {
            //        _delegate = delegate;
            _connection = [[NSURLConnection alloc]
                           initWithRequest:[NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]
                           delegate:self
                           startImmediately:NO];
            [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [_connection start];
        }
    });
}

#pragma mark - Public methods
-(void)cancelFetchClearDelegate:(BOOL)clearDelegate
{
    _canceled = YES;
    
    if (clearDelegate)
    {
        _delegate = nil;
    }
    
    if (_connection)
    {
        [_connection cancel];
        _connection = nil;
    }
}

-(void)cancelFetch
{
    [self cancelFetchClearDelegate:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_connection == connection)
    {
        if (!_data)
            _data = [[NSMutableData alloc] initWithCapacity:2024];
        
        [_data appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_connection == connection)
    {
        [self ruAsynchronousUIImageFinishedWithImage:nil error:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_connection == connection)
    {
        if (!self.canceled)
        {
            UIImage* image = [[UIImage alloc] initWithData:_data];
            
            if (image)
                [fetchedImages setObject:image forKey:_cacheName];
            else
                [fetchedImages removeObjectForKey:_cacheName];
            
#if kAsynchronousUIImageRequestEnableShowLastImage
            if (showLastImageView)
                [showLastImageView setImage:image];
#endif
            
            [self ruAsynchronousUIImageFinishedWithImage:image error:nil];
        }
    }
}

#pragma mark - Static methods
+(UIImage*)cachedImageForCacheName:(NSString*)cacheName
{
    return [fetchedImages objectForKey:cacheName];
}

+(void)removeCacheImageByCacheName:(NSString*)cacheName
{
    [fetchedImages removeObjectForKey:cacheName];
}

+(void)clearCache
{
    [fetchedImages removeAllObjects];
}

@end
