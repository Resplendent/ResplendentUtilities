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

-(void)fetchImageFromURLString:(NSString *)urlString
{
    [self fetchImageFromURLString:urlString withCacheName:urlString];
}

-(NSURL *)url
{
    return [_imageRequest url];
}

-(void)fetchImageFromURLString:(NSString*)urlString withCacheName:(NSString*)cacheName
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

    _imageRequest = [[AsynchronousUIImageRequest alloc] initAndFetchWithURLString:urlString cacheName:cacheName block:^(UIImage *image, NSError *error) {
        _imageRequest = nil;
        
        if (_spinner)
        {
            [_spinner stopAnimating];
            [_spinner removeFromSuperview];;
            _spinner = nil;
        }
        
        [self setImage:image];
        
        if (image)
            {
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

@end
