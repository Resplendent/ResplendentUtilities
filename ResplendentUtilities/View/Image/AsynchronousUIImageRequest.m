//
//  AsynchronousUIImageRequest.m
//  Crapple
//
//  Created by Benjamin Maer on 5/3/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "AsynchronousUIImageRequest.h"
#import "RUConstants.h"

#if kAsynchronousUIImageRequestEnableShowLastImage
static UIImageView* showLastImageView;
#endif


@implementation AsynchronousUIImageRequest

static NSMutableDictionary* fetchedImages;

+(void)initialize
{
    if (self == [AsynchronousUIImageRequest class])
    {
        fetchedImages = [NSMutableDictionary dictionary];
    }
}

-(id)initAndFetchWithURLString:(NSString*)urlString block:(imageErrorBlock)block
{
    return [self initAndFetchWithURLString:urlString cacheName:urlString block:block];
}

-(id)initAndFetchWithURLString:(NSString*)urlString cacheName:(NSString *)cacheName block:(imageErrorBlock)block
{
    return [self initAndFetchWithURL:[NSURL URLWithString:urlString] cacheName:cacheName block:block];
}

-(id)initAndFetchWithURL:(NSURL*)url block:(imageErrorBlock)block
{
    return [self initAndFetchWithURL:url cacheName:url.absoluteString block:block];
}

-(id)initAndFetchWithURL:(NSURL*)url cacheName:(NSString*)cacheName block:(imageErrorBlock)block
{
    if (!url)
        [NSException raise:NSInvalidArgumentException format:@"Can't fetch image without a url"];
    
    if (self = [self init])
    {
        _cacheName = (cacheName ? cacheName : url.absoluteString);
        _url = url;
        [self fetchImageWithBlock:block];
    }
    
    return self;
}

-(void)dealloc
{
    [self cancelFetch];
}

#pragma mark - Private methods
-(void)ruAsynchronousUIImageRequestCallBlock:(imageErrorBlock)block withImage:(UIImage*)image error:(NSError*)error
{
    if (block)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
            {
                block(image,error);
            }
        });
    }
}

#pragma mark - Public methods
-(void)fetchImageWithBlock:(imageErrorBlock)block
{
    [self cancelFetch];
    
    UIImage* cachedImage = [AsynchronousUIImageRequest cachedImageForCacheName:_cacheName];
    
    if (cachedImage)
    {
#if kAsynchronousUIImageRequestEnableShowLastImage
        if (showLastImageView)
            [showLastImageView setImage:cachedImage];
#endif
        [self ruAsynchronousUIImageRequestCallBlock:block withImage:cachedImage error:nil];
    }
    else
    {
        _block = block;
        _connection = [[NSURLConnection alloc]
                       initWithRequest:[NSURLRequest requestWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0]
                       delegate:self
                       startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    }
}

-(void)cancelFetch
{
    if (_connection)
    {
        [_connection cancel];
        _connection = nil;
    }
}

#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData
{
    if (!_data)
        _data = [[NSMutableData alloc] initWithCapacity:2024];
    
    [_data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error downloading from url %@ with error %@",self.url,error);
    [self ruAsynchronousUIImageRequestCallBlock:_block withImage:nil error:error];
    _block = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    //    dispatch_async(kAsynchronousUIImageRequestQueueFinishedRequest, ^{
    UIImage* image = [[UIImage alloc] initWithData:_data];
    
    if (image)
        [fetchedImages setObject:image forKey:_cacheName];
    else
        [fetchedImages removeObjectForKey:_cacheName];
    
    _data = nil;
    _connection = nil;
    
#if kAsynchronousUIImageRequestEnableShowLastImage
    if (showLastImageView)
        [showLastImageView setImage:image];
#endif

    [self ruAsynchronousUIImageRequestCallBlock:_block withImage:image error:nil];
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

#if kAsynchronousUIImageRequestEnableShowLastImage
#pragma mark Debug methods
+(void)showLastImageOnView:(UIView*)view atFrame:(CGRect)showFrame withContentMode:(UIViewContentMode)contentMode
{
    [self hideLastImage];
    
    showLastImageView = [UIImageView new];
    [showLastImageView setFrame:showFrame];
    [showLastImageView setContentMode:contentMode];
    [view addSubview:showLastImageView];
}

+(void)hideLastImage
{
    [showLastImageView removeFromSuperview];
    showLastImageView = nil;
}
#endif

@end
