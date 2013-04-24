//
//  UIButton+RUAsynchronousImageFetching.m
//  Albumatic
//
//  Created by Benjamin Maer on 4/23/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIButton+RUAsynchronousImageFetching.h"

#import "AsynchronousUIImageRequest.h"

#import <objc/runtime.h>

NSString* const kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest = @"kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest";
NSString* const kRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner = @"kRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner";
NSString* const kRUAsynchronousImageFetchingAssociatedObjectKeySpinner = @"kRUAsynchronousImageFetchingAssociatedObjectKeySpinner";

typedef enum{
    RUAsynchronousImageFetchingImageDestinationNormal = 0,
    RUAsynchronousImageFetchingImageDestinationBackground
}RUAsynchronousImageFetchingImageDestination;

@interface UIButton (RUAsynchronousImageFetchingPrivate)

@property (nonatomic, strong) AsynchronousUIImageRequest* imageRequest;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, assign) NSNumber* loadsUsingSpinnerNumber;

//Requires a completion block. Performs all the networking functionality. The completion block is expected to set the image
-(void)ruFetchImageForButtonAsynchronouslyAtUrl:(NSURL *)url forState:(UIControlState)state destination:(RUAsynchronousImageFetchingImageDestination)destination;

-(void)removeSpinner;

@end

@implementation UIButton (RUAsynchronousImageFetching)

-(void)ruCancelAsynchronousImageFetching
{
    if (self.imageRequest)
    {
        [self.imageRequest cancelFetch];
        [self setImageRequest:nil];
    }
}

-(void)ruFetchBackgroundImageAsynchronouslyAtUrl:(NSURL *)url forState:(UIControlState)state
{
    [self ruFetchImageForButtonAsynchronouslyAtUrl:url forState:state destination:RUAsynchronousImageFetchingImageDestinationBackground];
}

-(void)ruFetchImageAsynchronouslyAtUrl:(NSURL *)url forState:(UIControlState)state
{
    [self ruFetchImageForButtonAsynchronouslyAtUrl:url forState:state destination:RUAsynchronousImageFetchingImageDestinationNormal];
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

@implementation UIButton (RUAsynchronousImageFetchingPrivate)

#pragma mark - Setter methods
-(void)setLoadsUsingSpinnerNumber:(NSNumber *)loadsUsingSpinnerNumber
{
    objc_setAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner,
                             loadsUsingSpinnerNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImageRequest:(AsynchronousUIImageRequest *)imageRequest
{
    objc_setAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             imageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setSpinner:(UIActivityIndicatorView *)spinner
{
    objc_setAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeySpinner,
                             spinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter methods
-(NSNumber *)loadsUsingSpinnerNumber
{
    return objc_getAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
}

-(AsynchronousUIImageRequest *)imageRequest
{
    return objc_getAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

-(UIActivityIndicatorView *)spinner
{
    return objc_getAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
}

#pragma mark - Request sending
-(void)ruFetchImageForButtonAsynchronouslyAtUrl:(NSURL *)url forState:(UIControlState)state destination:(RUAsynchronousImageFetchingImageDestination)destination
{
//    if (!block)
//        [NSException raise:NSInvalidArgumentException format:@"%@ should not encounter this method without a block",self];

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
        
        switch (destination)
        {
            case RUAsynchronousImageFetchingImageDestinationNormal:
                [self setImage:image forState:state];
                break;
                
            case RUAsynchronousImageFetchingImageDestinationBackground:
                [self setBackgroundImage:image forState:state];
                break;
                
            default:
                [NSException raise:NSInvalidArgumentException format:@"unhandled destination %i",destination];
                break;
        }
    }]];
}

-(void)removeSpinner
{
    if (self.spinner)
    {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        [self setSpinner:nil];
    }
}

@end

//@implementation UIButton
//
//-(void)dealloc
//{
//    [self ruCancelAsynchronousImageFetching];
//    [self setLoadsUsingSpinnerNumber:nil];
//    [self removeSpinner];
//}
//
//@end


