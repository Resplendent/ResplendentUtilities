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

static dispatch_queue_t kAsynchronousUIImageRequestQueueNSURLRequest;
//static dispatch_queue_t kAsynchronousUIImageRequestQueueFinishedRequest;



@implementation AsynchronousUIImageRequest

@synthesize url = _url;

static NSMutableDictionary* fetchedImages;

+(void)initialize
{
    if (self == [AsynchronousUIImageRequest class])
    {
        fetchedImages = [NSMutableDictionary dictionary];
        kAsynchronousUIImageRequestQueueNSURLRequest = dispatch_queue_create("com.respledentUtilities.asynchronousUIImageRequest.nsurlrequests", 0);
//        kAsynchronousUIImageRequestQueueFinishedRequest = dispatch_queue_create("com.respledentUtilities.asynchronousUIImageRequest.finishedrequest", 0);
    }
}

-(id)initAndFetchWithURL:(NSString*)anUrl withBlock:(imageErrorBlock)block
{
    return [self initAndFetchWithURL:anUrl andCacheName:anUrl withBlock:block];
}

-(id)initAndFetchWithURL:(NSString *)anUrl andCacheName:(NSString *)cacheName withBlock:(imageErrorBlock)block
{
    if (!anUrl || anUrl.length == 0)
    {
        RUDLog(@"has nil url");
        if (block)
            block(nil,[NSError errorWithDomain:@"Tried to fetch an image with a nil url" code:500 userInfo:nil]);
        return nil;
    }

    if (self = [self init])
    {
        _cacheName = (cacheName ? cacheName : anUrl);
        [self setUrl:anUrl];
        [self fetchImageWithBlock:block];
    }

    return self;
}

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

        if (block)
            block(cachedImage,nil);
    }
    else
    {
        _block = block;
        _connection = [[NSURLConnection alloc]
                       initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0]
                       delegate:self
                       startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    }
}

-(void)cancelFetch
{
    [_connection cancel];
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
    if (_block)
        _block(nil,error);
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_block)
                _block(image,nil);
        });
//    });
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
