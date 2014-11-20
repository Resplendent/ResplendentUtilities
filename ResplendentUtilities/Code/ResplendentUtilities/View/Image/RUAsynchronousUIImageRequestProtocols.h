//
//  RUAsynchronousUIImageRequestProtocols.h
//  Resplendent
//
//  Created by Benjamin Maer on 6/19/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@class RUAsynchronousUIImageRequest;





@protocol RUAsynchronousUIImageRequestDelegate <NSObject>

-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest*)asynchronousUIImageRequest didFinishLoadingWithImage:(UIImage*)image;
-(void)asynchronousUIImageRequest:(RUAsynchronousUIImageRequest*)asynchronousUIImageRequest didFailLoadingWithError:(NSError*)error;

@end
