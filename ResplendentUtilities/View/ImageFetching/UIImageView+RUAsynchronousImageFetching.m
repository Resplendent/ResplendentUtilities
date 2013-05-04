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

@property (nonatomic, strong) AsynchronousUIImageRequest* ruAsynchronousImageFetchingPrivateImageRequest;
@property (nonatomic, strong) UIActivityIndicatorView* ruAsynchronousImageFetchingPrivateSpinner;
@property (nonatomic, assign) NSNumber* ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber;

-(void)ruAsynchronousImageFetchingPrivateRemoveSpinner;

@end

@implementation UIImageView (RUAsynchronousImageFetching)

-(void)ruCancelAsynchronousImageFetching
{
    if (self.ruAsynchronousImageFetchingPrivateImageRequest)
    {
        [self.ruAsynchronousImageFetchingPrivateImageRequest cancelFetch];
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
    }
}

-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString
{
    [self ruFetchImageAsynchronouslyAtUrl:[NSURL URLWithString:urlString]];
}

-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url
{
    [self ruCancelAsynchronousImageFetching];

    if (self.ruLoadsUsingSpinner)
    {
        if (!self.ruAsynchronousImageFetchingPrivateSpinner)
        {
            [self setRuAsynchronousImageFetchingPrivateSpinner:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            [self addSubview:self.ruAsynchronousImageFetchingPrivateSpinner];
        }
        
        [self.ruAsynchronousImageFetchingPrivateSpinner startAnimating];
    }

    [self setRuAsynchronousImageFetchingPrivateImageRequest:[[AsynchronousUIImageRequest alloc] initAndFetchWithURL:url cacheName:url.absoluteString block:^(UIImage *image, NSError *error) {
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];

        [self ruAsynchronousImageFetchingPrivateRemoveSpinner];

        [self setImage:image];
    }]];
}

#pragma mark - Getter methods
-(BOOL)ruLoadsUsingSpinner
{
    return self.ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber.boolValue;
}

#pragma mark - Setter methods
-(void)setRuLoadsUsingSpinner:(BOOL)ruLoadsUsingSpinner
{
    [self setRuAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber:@(ruLoadsUsingSpinner)];
}

@end


@implementation UIImageView (RUAsynchronousImageFetchingPrivate)

#pragma mark - Content
-(void)ruAsynchronousImageFetchingPrivateRemoveSpinner
{
    if (self.ruAsynchronousImageFetchingPrivateSpinner)
    {
        [self.ruAsynchronousImageFetchingPrivateSpinner stopAnimating];
        [self.ruAsynchronousImageFetchingPrivateSpinner removeFromSuperview];
        [self setRuAsynchronousImageFetchingPrivateSpinner:nil];
    }
}

#pragma mark - Setters
-(void)setRuAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber:(NSNumber *)loadsUsingSpinnerNumber
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner,
                             loadsUsingSpinnerNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateImageRequest:(AsynchronousUIImageRequest *)imageRequest
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             imageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateSpinner:(UIActivityIndicatorView *)spinner
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner,
                             spinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter methods
-(NSNumber *)ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
}

-(AsynchronousUIImageRequest *)ruAsynchronousImageFetchingPrivateImageRequest
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

-(UIActivityIndicatorView *)ruAsynchronousImageFetchingPrivateSpinner
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner);
}

@end

