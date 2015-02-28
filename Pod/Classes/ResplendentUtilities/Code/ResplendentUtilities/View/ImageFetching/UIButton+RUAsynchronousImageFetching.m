//
//  UIButton+RUAsynchronousImageFetching.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/23/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIButton+RUAsynchronousImageFetching.h"
#import "RUDLog.h"
#import "RUDeallocHook.h"
#import "RUAsynchronousUIImageRequest.h"

#import <objc/runtime.h>

NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest";
NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDeallocHook = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDeallocHook";
NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner";
NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeySpinner = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeySpinner";
NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDestinationNumber = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDestinationNumber";
NSString* const kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyStateNumber = @"kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyStateNumber";

typedef enum{
    RUAsynchronousImageFetchingImageDestinationNormal = 0,
    RUAsynchronousImageFetchingImageDestinationBackground
}RUAsynchronousImageFetchingImageDestination;

@interface UIButton (RUAsynchronousImageFetchingPrivate) <RUAsynchronousUIImageRequestDelegate>

@property (nonatomic, readonly) RUAsynchronousImageFetchingImageDestination ruAsynchronousImageFetchingPrivateDestination;
@property (nonatomic, readonly) UIControlState ruAsynchronousImageFetchingPrivateState;

@property (nonatomic) RUDeallocHook* ruAsynchronousImageFetchingPrivateDeallocHook;
@property (nonatomic, strong) RUAsynchronousUIImageRequest* ruAsynchronousImageFetchingPrivateImageRequest;
@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, assign) NSNumber* loadsUsingSpinnerNumber;
@property (nonatomic, assign) NSNumber* ruAsynchronousImageFetchingPrivateDestinationNumber;
@property (nonatomic, assign) NSNumber* ruAsynchronousImageFetchingPrivateStateNumber;

//Requires a completion block. Performs all the networking functionality. The completion block is expected to set the image
-(void)ruFetchImageForButtonAsynchronouslyAtUrl:(NSURL *)url forState:(UIControlState)state destination:(RUAsynchronousImageFetchingImageDestination)destination;

-(void)removeSpinner;

@end

@implementation UIButton (RUAsynchronousImageFetching)

-(void)ruCancelAsynchronousImageFetching
{
    [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];

    if (self.ruAsynchronousImageFetchingPrivateImageRequest)
    {
        [self.ruAsynchronousImageFetchingPrivateImageRequest cancelFetch];
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
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
-(void)setRuAsynchronousImageFetchingPrivateStateNumber:(NSNumber *)ruAsynchronousImageFetchingPrivateStateNumber
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyStateNumber,
                             ruAsynchronousImageFetchingPrivateStateNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateDestinationNumber:(NSNumber *)ruAsynchronousImageFetchingPrivateDestinationNumber
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDestinationNumber,
                             ruAsynchronousImageFetchingPrivateDestinationNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setLoadsUsingSpinnerNumber:(NSNumber *)loadsUsingSpinnerNumber
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner,
                             loadsUsingSpinnerNumber,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateDeallocHook:(RUDeallocHook *)ruAsynchronousImageFetchingPrivateDeallocHook
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDeallocHook,
                             ruAsynchronousImageFetchingPrivateDeallocHook,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setRuAsynchronousImageFetchingPrivateImageRequest:(RUAsynchronousUIImageRequest *)ruAsynchronousImageFetchingPrivateImageRequest
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             ruAsynchronousImageFetchingPrivateImageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setSpinner:(UIActivityIndicatorView *)spinner
{
    objc_setAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeySpinner,
                             spinner,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter methods
-(RUAsynchronousImageFetchingImageDestination)ruAsynchronousImageFetchingPrivateDestination
{
    return (RUAsynchronousImageFetchingImageDestination)self.ruAsynchronousImageFetchingPrivateDestinationNumber.integerValue;
}

-(UIControlState)ruAsynchronousImageFetchingPrivateState
{
    return self.ruAsynchronousImageFetchingPrivateStateNumber.integerValue;
}

-(NSNumber *)ruAsynchronousImageFetchingPrivateStateNumber
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyStateNumber);
}

-(NSNumber *)ruAsynchronousImageFetchingPrivateDestinationNumber
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDestinationNumber);
}

-(NSNumber *)loadsUsingSpinnerNumber
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
}

-(RUDeallocHook *)ruAsynchronousImageFetchingPrivateDeallocHook
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyDeallocHook);
}

-(RUAsynchronousUIImageRequest *)ruAsynchronousImageFetchingPrivateImageRequest
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

-(UIActivityIndicatorView *)spinner
{
    return objc_getAssociatedObject(self, &kUIButtonRUAsynchronousImageFetchingAssociatedObjectKeyLoadUsingSpinner);
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

    [self setRuAsynchronousImageFetchingPrivateStateNumber:@(state)];
    [self setRuAsynchronousImageFetchingPrivateDestinationNumber:@(destination)];
    [self setRuAsynchronousImageFetchingPrivateImageRequest:[[RUAsynchronousUIImageRequest alloc]initAndFetchWithURL:url delegate:self]];

    __weak typeof(self.ruAsynchronousImageFetchingPrivateImageRequest) imageRequestPointer = self.ruAsynchronousImageFetchingPrivateImageRequest;
    [self setRuAsynchronousImageFetchingPrivateDeallocHook:[RUDeallocHook deallocHookWithBlock:^{
        [imageRequestPointer cancelFetch];
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

#pragma mark - RUAsynchronousUIImageRequestDelegate methods
-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest *)asynchronousUIImageRequest didFinishLoadingWithImage:(UIImage *)image
{
    if (asynchronousUIImageRequest == self.ruAsynchronousImageFetchingPrivateImageRequest)
    {
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
        [self removeSpinner];
        
        switch (self.ruAsynchronousImageFetchingPrivateDestination)
        {
            case RUAsynchronousImageFetchingImageDestinationNormal:
                [self setImage:image forState:self.ruAsynchronousImageFetchingPrivateState];
                break;
                
            case RUAsynchronousImageFetchingImageDestinationBackground:
                [self setBackgroundImage:image forState:self.ruAsynchronousImageFetchingPrivateState];
                break;
                
            default:
                [NSException raise:NSInvalidArgumentException format:@"unhandled destination %i",self.ruAsynchronousImageFetchingPrivateDestination];
                break;
        }
        
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
        [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];
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
        [self setRuAsynchronousImageFetchingPrivateImageRequest:nil];
        [self setRuAsynchronousImageFetchingPrivateDeallocHook:nil];
    }
    else
    {
        RUDLog(@"ignoring request %@",asynchronousUIImageRequest);
    }
}

@end
