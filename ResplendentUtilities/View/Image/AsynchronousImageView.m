//
//  AsynchronousImageView.m
//  Crapple
//
//  Created by Ben on 5/21/12.
//  Copyright (c) 2012 Resplendent G.P.. All rights reserved.
//

#import "AsynchronousImageView.h"
#import "AsynchronousUIImageRequest.h"
#import "RUConstants.h"

@implementation AsynchronousImageView

@synthesize loadsUsingSpinner;
@synthesize fadeInDuration;

-(id)init
{
    if (self = [super init])
    {
        [self setLoadsUsingSpinner:NO];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_spinner setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
}

-(void)dealloc
{
    [self cancelFetch];
}

//-(void)removeFromSuperview
//{
//    [self cancelFetch];
//    [super removeFromSuperview];
//}

#pragma mark - Getter method
-(BOOL)isLoading
{
    return _imageRequest != nil;
}

#pragma mark - Public methods
-(void)cancelFetch
{
    [_imageRequest cancelFetch];
    _imageRequest = nil;
}

-(void)fetchImageFromURL:(NSURL*)url
{
    [self fetchImageFromURL:url withCacheName:url.absoluteString];
}

-(void)fetchImageFromURL:(NSURL*)url withCacheName:(NSString*)cacheName
{
    [self cancelFetch];
    
    [self setImage:nil];
    
    if (self.loadsUsingSpinner)
    {
        if (!_spinner)
        {
            _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self addSubview:_spinner];
        }
        
        [_spinner startAnimating];
    }
    
    _imageRequest = [[AsynchronousUIImageRequest alloc] initAndFetchWithURL:url cacheName:cacheName block:^(UIImage *image, NSError *error) {
        _imageRequest = nil;
        
        if (_spinner)
        {
            [_spinner stopAnimating];
            [_spinner removeFromSuperview];;
            _spinner = nil;
        }
        
        //            RUDLog(@"setting image");
        [self setImage:image];
        //            [self drawRect:self.bounds];
        
        if (image)
        {
            //                if (self.frame.size.width == 0 || self.frame.size.height == 0)
            //                    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height);
            
            CGFloat alpha = self.alpha;
            if (self.fadeInDuration > 0)
            {
                [self setAlpha:0.0f];
                [UIView animateWithDuration:self.fadeInDuration animations:^{
                    [self setAlpha:alpha];
                }];
            }
        }
    }];
}

-(void)fetchImageFromURLString:(NSString*)anUrl
{
    [self fetchImageFromURLString:anUrl withCacheName:anUrl];
}

//-(NSString *)url
//{
//    return [_imageRequest url];
//}

-(void)fetchImageFromURLString:(NSString*)anUrl withCacheName:(NSString*)cacheName
{
    [self fetchImageFromURL:[NSURL URLWithString:anUrl] withCacheName:cacheName];
}

@end
