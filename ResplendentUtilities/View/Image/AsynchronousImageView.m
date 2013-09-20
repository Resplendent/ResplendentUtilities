//
//  AsynchronousImageView.m
//  Crapple
//
//  Created by Ben on 5/21/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//
//
//#import "AsynchronousImageView.h"
//#import "RUAsynchronousUIImageRequest.h"
//#import "RUConstants.h"
//
//@interface AsynchronousImageView ()
//
//-(void)removeSpinner;
//
//@end
//
//@implementation AsynchronousImageView
//
//@synthesize loadsUsingSpinner;
//@synthesize fadeInDuration;
//
//-(id)init
//{
//    if (self = [super init])
//    {
//        [self setLoadsUsingSpinner:NO];
//    }
//
//    return self;
//}
//
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    [_spinner setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
//}
//
//-(void)dealloc
//{
//    [self cancelFetch];
//}
//
//#pragma mark - Getter method
//-(BOOL)isLoading
//{
//    return _imageRequest != nil;
//}
//
//-(NSURL *)url
//{
//    return _imageRequest.url;
//}
//
//#pragma mark - Public methods
//-(void)cancelFetch
//{
//    [_imageRequest cancelFetch];
//    _imageRequest = nil;
//}
//
//-(void)fetchImageFromURL:(NSURL*)url
//{
//    [self fetchImageFromURL:url withCacheName:url.absoluteString];
//}
//
//-(void)fetchImageFromURL:(NSURL*)url withCacheName:(NSString*)cacheName
//{
//    [self cancelFetch];
//    
//    [self setImage:nil];
//    
//    if (self.loadsUsingSpinner)
//    {
//        if (!_spinner)
//        {
//            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            [self addSubview:_spinner];
//        }
//        
//        [_spinner startAnimating];
//    }
//
//    _imageRequest = [[RUAsynchronousUIImageRequest alloc]initAndFetchWithURL:url cacheName:cacheName delegate:self];
////    _imageRequest = [[RUAsynchronousUIImageRequest alloc]initAndFetchWithURLString:urlString cacheName:cacheName delegate:self];
//}
//
//#pragma mark - Update Content
//-(void)removeSpinner
//{
//    if (_spinner)
//    {
//        [_spinner stopAnimating];
//        [_spinner removeFromSuperview];;
//        _spinner = nil;
//    }
//}
//
//#pragma mark - RUAsynchronousUIImageRequestDelegate methods
//-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest *)asynchronousUIImageRequest didFinishLoadingWithImage:(UIImage *)image
//{
//    if (asynchronousUIImageRequest == _imageRequest)
//    {
//        _imageRequest = nil;
//
//        [self removeSpinner];
//
//        [self setImage:image];
//
//        if (image && self.fadeInDuration > 0)
//        {
//            CGFloat alpha = self.alpha;
//            [self setAlpha:0.0f];
//            [UIView animateWithDuration:self.fadeInDuration animations:^{
//                [self setAlpha:alpha];
//            }];
//        }
//    }
//    else
//    {
//        RUDLog(@"ingoring request %@",asynchronousUIImageRequest);
//    }
//}
//
//-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest *)asynchronousUIImageRequest didFailLoadingWithError:(NSError *)error
//{
//    RUDLog(@"%@",error);
//    if (asynchronousUIImageRequest == _imageRequest)
//    {
//        _imageRequest = nil;
//        [self removeSpinner];
//    }
//    else
//    {
//        RUDLog(@"ingoring request %@",asynchronousUIImageRequest);
//    }
//}
//
//-(void)fetchImageFromURLString:(NSString*)anUrl
//{
//    [self fetchImageFromURLString:anUrl withCacheName:anUrl];
//}
//
//-(void)fetchImageFromURLString:(NSString*)anUrl withCacheName:(NSString*)cacheName
//{
//    [self fetchImageFromURL:[NSURL URLWithString:anUrl] withCacheName:cacheName];
//}
//
//@end
