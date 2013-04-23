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

@interface UIButton (RUAsynchronousImageFetchingPrivate)

@property (nonatomic, strong) AsynchronousUIImageRequest* imageRequest;

@end

@implementation UIButton (RUAsynchronousImageFetching)

-(void)fetchBackgroundImageAtUrl:(NSURL*)url forState:(UIControlState)state
{
    
}

@end

@implementation UIButton (RUAsynchronousImageFetchingPrivate)

#pragma mark - Setter methods
-(void)setImageRequest:(AsynchronousUIImageRequest *)imageRequest
{
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest,
                             imageRequest,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}

#pragma mark - Getter methods
-(AsynchronousUIImageRequest *)imageRequest
{
    return objc_getAssociatedObject(self, &kRUAsynchronousImageFetchingAssociatedObjectKeyImageRequest);
}

@end
