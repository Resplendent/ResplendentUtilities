//
//  RUImageCaptureViewProtocols.h
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <Foundation/Foundation.h>





@class RUImageCaptureView;





@protocol RUImageCaptureView_imageDataCaptureDelegate <NSObject>

-(void)ruImageCaptureView:(RUImageCaptureView*)imageCaptureView didCaptureImageData:(NSData*)imageData metaData:(NSDictionary*)metaData;
-(void)ruImageCaptureView:(RUImageCaptureView*)imageCaptureView didFailCaptureImageDataCaptureWithError:(NSError*)error;

@end
