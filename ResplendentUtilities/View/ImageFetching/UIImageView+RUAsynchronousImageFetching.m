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
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration";

@interface UIImageView (RUAsynchronousImageFetchingPrivate)

@property (nonatomic) AsynchronousUIImageRequest* ruAsynchronousImageFetchingPrivateImageRequest;
@property (nonatomic) UIActivityIndicatorView* ruAsynchronousImageFetchingPrivateSpinner;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateSpinnerStyleNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateFadeInDuration;

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
    [self ruFetchImageAsynchronouslyAtUrl:[NSURL URLWithString:urlString] cacheName:urlString];
}

-(void)ruFetchImageAsynchronouslyAtUrlString:(NSString*)urlString cacheName:(NSString*)cacheName
{
    [self ruFetchImageAsynchronouslyAtUrl:[NSURL URLWithString:urlString] cacheName:cacheName];
}

-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url
{
    [self ruFetchImageAsynchronouslyAtUrl:url cacheName:url.absoluteString];
}

-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL*)url cacheName:(NSString*)cacheName;
{
    [self ruCancelAsynchronousImageFetching];

    if (self.ruLoadsUsingSpinner)
    {
        if (!self.ruAsynchronousImageFetchingPrivateSpinner)
        {
            [self setRuAsynchronousImageFetchingPrivateSpinner:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.spinnerStyle]];
            [self addSubview:self.ruAsynchronousImageFetchingPrivateSpinner];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.ruAsynchronousImageFetchingPrivateSpinner setCenter:(CGPoint){CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds)}];
            });
        }

        [self.ruAsynchronousImageFetchingPrivateSpinner startAnimating];
    }
    else
    {
        [self ruAsynchronousImageFetchingPrivateRemoveSpinner];
    }

    if (self.ruClearImageOnFetch)
    {
        [self setImage:nil];
    }

    [self setRuAsynchronousImageFetchingPrivateImageRequest:[[AsynchronousUIImageRequest alloc] initAndFetchWithURL:url cacheName:cacheName block:^(UIImage *image, NSError *error) {
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];

        [self ruAsynchronousImageFetchingPrivateRemoveSpinner];

        [self setImage:image];

        if (self.ruFadeInDuration)
        {
            [self setAlpha:0.0f];
            [UIView animateWithDuration:self.ruFadeInDuration animations:^{
                [self setAlpha:1.0f];
            }];
        }
    }]];
}

#pragma mark - Getter methods
-(CGFloat)ruFadeInDuration
{
    return self.ruAsynchronousImageFetchingPrivateFadeInDuration.floatValue;
}

-(BOOL)ruLoadsUsingSpinner
{
    return self.ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber.boolValue;
}

-(UIActivityIndicatorViewStyle)spinnerStyle
{
    NSNumber* spinnerStyleNumber = self.ruAsynchronousImageFetchingPrivateSpinnerStyleNumber;
    if (spinnerStyleNumber)
    {
        return spinnerStyleNumber.integerValue;
    }
    else
    {
        return UIActivityIndicatorViewStyleGray;
    }
}

-(BOOL)ruClearImageOnFetch
{
    return self.ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber.boolValue;
}

#pragma mark - Setters
-(void)setRuFadeInDuration:(CGFloat)ruFadeInDuration
{
    [self setRuAsynchronousImageFetchingPrivateFadeInDuration:@(ruFadeInDuration)];
}

-(void)setSpinnerStyle:(UIActivityIndicatorViewStyle)spinnerStyle
{
    [self setRuAsynchronousImageFetchingPrivateSpinnerStyleNumber:@(spinnerStyle)];
}

-(void)setRuLoadsUsingSpinner:(BOOL)ruLoadsUsingSpinner
{
    [self setRuAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber:@(ruLoadsUsingSpinner)];
}

-(void)setRuClearImageOnFetch:(BOOL)ruClearImageOnFetch
{
    [self setRuAsynchronousImageFetchingPrivateClearImageOnFetchNumber:@(ruClearImageOnFetch)];
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
-(void)setRuAsynchronousImageFetchingPrivateFadeInDuration:(NSNumber *)ruAsynchronousImageFetchingPrivateFadeInDuration
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration,
                             ruAsynchronousImageFetchingPrivateFadeInDuration,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateSpinnerStyleNumber:(NSNumber *)ruAsynchronousImageFetchingPrivateSpinnerStyleNumber
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber,
                             ruAsynchronousImageFetchingPrivateSpinnerStyleNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateClearImageOnFetchNumber:(NSNumber *)ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch,
                             ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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
-(NSNumber *)ruAsynchronousImageFetchingPrivateFadeInDuration
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration);
}

-(NSNumber *)ruAsynchronousImageFetchingPrivateSpinnerStyleNumber
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber);
}

-(NSNumber *)ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch);
}

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

