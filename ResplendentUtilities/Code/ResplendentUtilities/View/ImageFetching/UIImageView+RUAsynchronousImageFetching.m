//
//  UIImageView+RUAsynchronousImageFetching.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/24/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIImageView+RUAsynchronousImageFetching.h"
#import "RUDeallocHook.h"
#import "RUAsynchronousUIImageRequest.h"
#import "RUDLog.h"
#import <objc/runtime.h>





NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequestDeallocHook = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequestDeallocHook";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyClearImageOnFetch";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinnerStyleNumber";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyFadeInDuration";
NSString* const kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyDelegate = @"kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyDelegate";

UIActivityIndicatorViewStyle const kUIImageViewRUAsynchronousImageFetchingDefaultSpinnerStyle = UIActivityIndicatorViewStyleGray;





@interface UIImageView (RUAsynchronousImageFetchingPrivate)

@property (nonatomic) RUDeallocHook* ruAsynchronousImageFetchingPrivateDeallocHook;
@property (nonatomic) RUAsynchronousUIImageRequest* ruAsynchronousImageFetchingPrivateImageRequest;
@property (nonatomic) UIActivityIndicatorView* ruAsynchronousImageFetchingPrivateSpinner;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateSpinnerStyleNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber;
@property (nonatomic) NSNumber* ruAsynchronousImageFetchingPrivateFadeInDuration;

-(void)ruCenterSpinner;

@end





@implementation UIImageView (RUAsynchronousImageFetching)

-(void)ruCancelAsynchronousImageFetching
{
    [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];

    [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
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

    [self setRuAsynchronousImageFetchingSpinnerVisibility:self.ruLoadsUsingSpinner];

    if (self.ruClearImageOnFetch)
    {
        [self setImage:nil];
    }

    [self setRuAsynchronousImageFetchingPrivateImageRequest:[[RUAsynchronousUIImageRequest alloc]initAndFetchWithURL:url cacheName:cacheName delegate:self]];

    __weak typeof(self.ruAsynchronousImageFetchingPrivateImageRequest) imageRequestPointer = self.ruAsynchronousImageFetchingPrivateImageRequest;
    [self setRuAsynchronousImageFetchingPrivateDeallocHook:[RUDeallocHook deallocHookWithBlock:^{
        [imageRequestPointer cancelFetch];
    }]];
}

#pragma mark - Spinner
-(BOOL)ruAsynchronousImageFetchingSpinnerVisibility
{
    return self.ruAsynchronousImageFetchingPrivateSpinner.isAnimating;
}

-(void)setRuAsynchronousImageFetchingSpinnerVisibility:(BOOL)ruAsynchronousImageFetchingSpinnerVisibility
{
    if (self.ruAsynchronousImageFetchingSpinnerVisibility == ruAsynchronousImageFetchingSpinnerVisibility)
        return;

    if (ruAsynchronousImageFetchingSpinnerVisibility)
    {
        if (!self.ruAsynchronousImageFetchingPrivateSpinner)
        {
            [self setRuAsynchronousImageFetchingPrivateSpinner:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.ruAsynchronousImageFetchingSpinnerStyle]];
            [self addSubview:self.ruAsynchronousImageFetchingPrivateSpinner];
            [self setAutoresizesSubviews:YES];
            [self ruCenterSpinner];
            [self.ruAsynchronousImageFetchingPrivateSpinner setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        }
        
        [self.ruAsynchronousImageFetchingPrivateSpinner startAnimating];
    }
    else
    {
        if (self.ruAsynchronousImageFetchingPrivateSpinner)
        {
            [self.ruAsynchronousImageFetchingPrivateSpinner stopAnimating];
            [self.ruAsynchronousImageFetchingPrivateSpinner removeFromSuperview];
            [self setRuAsynchronousImageFetchingPrivateSpinner:nil];
        }
    }
}

#pragma mark - Getter methods
-(id<RUAsynchronousImageFetchingDelegate>)ruAsynchronousImageFetchingDelegate
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyDelegate);
}

-(CGFloat)ruFadeInDuration
{
    return self.ruAsynchronousImageFetchingPrivateFadeInDuration.floatValue;
}

-(BOOL)ruLoadsUsingSpinner
{
    return self.ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber.boolValue;
}

-(UIActivityIndicatorViewStyle)ruAsynchronousImageFetchingSpinnerStyle
{
    NSNumber* spinnerStyleNumber = self.ruAsynchronousImageFetchingPrivateSpinnerStyleNumber;
    if (spinnerStyleNumber)
    {
        return spinnerStyleNumber.integerValue;
    }
    else
    {
        return kUIImageViewRUAsynchronousImageFetchingDefaultSpinnerStyle;
    }
}

-(BOOL)ruClearImageOnFetch
{
    return self.ruAsynchronousImageFetchingPrivateClearImageOnFetchNumber.boolValue;
}

#pragma mark - Setters
-(void)setRuAsynchronousImageFetchingDelegate:(id<RUAsynchronousImageFetchingDelegate>)ruAsynchronousImageFetchingDelegate
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyDelegate,
                             ruAsynchronousImageFetchingDelegate,
                             OBJC_ASSOCIATION_ASSIGN);
}

-(void)setRuFadeInDuration:(CGFloat)ruFadeInDuration
{
    [self setRuAsynchronousImageFetchingPrivateFadeInDuration:@(ruFadeInDuration)];
}

-(void)setRuAsynchronousImageFetchingSpinnerStyle:(UIActivityIndicatorViewStyle)ruAsynchronousImageFetchingSpinnerStyle
{
    [self setRuAsynchronousImageFetchingPrivateSpinnerStyleNumber:@(ruAsynchronousImageFetchingSpinnerStyle)];
}

-(void)setRuLoadsUsingSpinner:(BOOL)ruLoadsUsingSpinner
{
    [self setRuAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber:@(ruLoadsUsingSpinner)];
}

-(void)setRuClearImageOnFetch:(BOOL)ruClearImageOnFetch
{
    [self setRuAsynchronousImageFetchingPrivateClearImageOnFetchNumber:@(ruClearImageOnFetch)];
}


#pragma mark - RUAsynchronousUIImageRequestDelegate methods
-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest *)asynchronousUIImageRequest didFinishLoadingWithImage:(UIImage *)image
{
    if (asynchronousUIImageRequest == self.ruAsynchronousImageFetchingPrivateImageRequest)
    {
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];

        [self setRuAsynchronousImageFetchingSpinnerVisibility:NO];
        
        [self setImage:image];

        [self.ruAsynchronousImageFetchingDelegate ruAsynchronousFetchingImageView:self finishedFetchingImage:image];
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
        [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];

        if (self.ruFadeInDuration)
        {
            [self setAlpha:0.0f];
            [UIView animateWithDuration:self.ruFadeInDuration animations:^{
                [self setAlpha:1.0f];
            }];
        }
    }
    else
    {
        RUDLog(@"ignoring request %@",asynchronousUIImageRequest);
    }
}

-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest *)asynchronousUIImageRequest didFailLoadingWithError:(NSError *)error
{
    RUDLog(@"%@",error);
    if (asynchronousUIImageRequest == self.ruAsynchronousImageFetchingPrivateImageRequest)
    {
        [self setRuAsynchronousImageFetchingSpinnerVisibility:NO];
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
        [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];
    }
    else
    {
        RUDLog(@"ignoring request %@",asynchronousUIImageRequest);
    }
}

#pragma mark - RUDeallocHookDelegate methods
-(void)deallocHookDidDealloc:(RUDeallocHook*)deallocHook
{
    [self ruCancelAsynchronousImageFetching];
}

@end


@implementation UIImageView (RUAsynchronousImageFetchingPrivate)

#pragma mark - Content
-(void)ruCenterSpinner
{
    [self.ruAsynchronousImageFetchingPrivateSpinner setCenter:(CGPoint){CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds)}];
}

#pragma mark - Setters
-(void)setRuAsynchronousImageFetchingPrivateDeallocHook:(RUDeallocHook *)ruAsynchronousImageFetchingPrivateDeallocHook
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequestDeallocHook,
                             ruAsynchronousImageFetchingPrivateDeallocHook,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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

-(void)setRuAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber:(NSNumber *)ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner,
                             ruAsynchronousImageFetchingPrivateLoadsUsingSpinnerNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateImageRequest:(RUAsynchronousUIImageRequest *)ruAsynchronousImageFetchingPrivateImageRequest
{
    RUAsynchronousUIImageRequest* oldRequest = self.ruAsynchronousImageFetchingPrivateImageRequest;
    if (oldRequest)
    {
        [oldRequest cancelFetch];
    }

    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             ruAsynchronousImageFetchingPrivateImageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateSpinner:(UIActivityIndicatorView *)spinner
{
    objc_setAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner,
                             spinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter methods
-(RUDeallocHook *)ruAsynchronousImageFetchingPrivateDeallocHook
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequestDeallocHook);
}

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

-(RUAsynchronousUIImageRequest *)ruAsynchronousImageFetchingPrivateImageRequest
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

-(UIActivityIndicatorView *)ruAsynchronousImageFetchingPrivateSpinner
{
    return objc_getAssociatedObject(self, &kUIImageViewRUAsynchronousImageFetchingAssociatedObjectKeySpinner);
}

@end
