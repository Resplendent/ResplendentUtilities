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
	
	__weak typeof(self) const self_weak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancelFetchClearDelegate:NO];
        self_weak.canceled = NO;
        
        UIImage* cachedImage = [RUAsynchronousUIImageRequest cachedImageForCacheName:self_weak.cacheName];
        
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
            self_weak.connection = [[NSURLConnection alloc]
                           initWithRequest:[NSURLRequest requestWithURL:self_weak.url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]
                           delegate:self
                           startImmediately:NO];
            [self_weak.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self_weak.connection start];
        }
    });
}

#pragma mark - Public methods
-(void)cancelFetchClearDelegate:(BOOL)clearDelegate
{
    [self setCanceled:YES];
    
    if (clearDelegate)
    {
        [self setDelegate:nil];
    }
    
    if (self.connection)
    {
        [self.connection cancel];
        [self setConnection:nil];
    }
}

-(void)cancelFetch
{
    [self cancelFetchClearDelegate:YES];
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.connection == connection)
    {
        if (!self.data)
			[self setData:[[NSMutableData alloc] initWithCapacity:2024]];
			
        [self.data appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.connection == connection)
    {
        [self ruAsynchronousUIImageFinishedWithImage:nil error:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.connection == connection)
    {
        if (!self.canceled)
        {
            UIImage* image = [[UIImage alloc] initWithData:self.data];
            
            if (image)
                [fetchedImages setObject:image forKey:self.cacheName];
            else
                [fetchedImages removeObjectForKey:self.cacheName];
            
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
