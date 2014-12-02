//
//  RUImageCaptureView.h
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUImageCaptureViewProtocols.h"
#import <AVFoundation/AVFoundation.h>





@interface RUImageCaptureView : UIView

@property (nonatomic, assign) id<RUImageCaptureView_imageDataCaptureDelegate> imageDataCaptureDelegate;
-(BOOL)performImageDataCapture; //Returns TRUE if attempt was made, otherwise FALSE.

@property (nonatomic, assign) BOOL imageCaptureIsRunning; //Shouldn't be used to disable camera streaming. If disabled, cannot capture an image from it.

@property (nonatomic, readonly) BOOL tapToFocusIsSupported;
@property (nonatomic, assign) BOOL enableTapToFocus;
@property (nonatomic, assign) CGSize tapToFocusSize;
@property (nonatomic, strong) UIColor* tapToFocusBorderColor;

@property (nonatomic, readonly) BOOL flashAvailable;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;

+(UIInterfaceOrientation)uiInterfaceOrientationForImageOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
																	 captureDevicePosition:(AVCaptureDevicePosition)captureDevicePosition;

@end
