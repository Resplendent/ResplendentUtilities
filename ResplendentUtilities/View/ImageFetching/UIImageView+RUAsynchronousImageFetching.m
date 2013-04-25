//
//  UIImageView+RUAsynchronousImageFetching.m
//  Albumatic
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIImageView+RUAsynchronousImageFetching.h"
#import "AsynchronousUIImageRequest.h"
#import <objc/runtime.h>

NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner";

@interface UIImageView (RUAsynchronousImageFetchingPrivate)

@property (nonatomic, strong) AsynchronousUIImageRequest* imageRequest;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, assign) NSNumber* loadsUsingSpinnerNumber;

-(void)removeSpinner;

@end

@implementation UIImageView (RUAsynchronousImageFetching)

-(void)ruCancelAsynchronousImageFetching
{
    if (self.imageRequest)
    {
        [self.imageRequest cancelFetch];
        [self setImageRequest:nil];
    }
}

-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url
{
    [self ruCancelAsynchronousImageFetching];

    if (self.loadsUsingSpinner)
    {
        if (!self.spinner)
        {
            [self setSpinner:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            [self addSubview:self.spinner];
        }
        
        [self.spinner startAnimating];
    }

    [self setImageRequest:[[AsynchronousUIImageRequest alloc] initAndFetchWithURL:url cacheName:url.absoluteString block:^(UIImage *image, NSError *error) {
        [self setImageRequest:nil];

        [self removeSpinner];

        [self setImage:image];
    }]];
}

#pragma mark - Getter methods
-(BOOL)loadsUsingSpinner
{
    return self.loadsUsingSpinnerNumber.boolValue;
}

#pragma mark - Setter methods
-(void)setLoadsUsingSpinner:(BOOL)loadsUsingSpinner
{
    [self setLoadsUsingSpinnerNumber:@(loadsUsingSpinner)];
}

@end


@implementation UIImageView (RUAsynchronousImageFetchingPrivate)

#pragma mark - Content
-(void)removeSpinner
{
    if (self.spinner)
    {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        [self setSpinner:nil];
    }
}

#pragma mark - Setters
-(void)setLoadsUsingSpinnerNumber:(NSNumber *)loadsUsingSpinnerNumber
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner,
                             loadsUsingSpinnerNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImageRequest:(AsynchronousUIImageRequest *)imageRequest
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             imageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setSpinner:(UIActivityIndicatorView *)spinner
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner,
                             spinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter methods
-(NSNumber *)loadsUsingSpinnerNumber
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
}

-(AsynchronousUIImageRequest *)imageRequest
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

-(UIActivityIndicatorView *)spinner
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner);
}

@end

