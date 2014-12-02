//
//  AVCaptureDevice+RUCaptureDevices.h
//  Camerama
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>





@interface AVCaptureDevice (RUCaptureDevices)

+(AVCaptureDevice *)ru_captureDeviceForPosition:(AVCaptureDevicePosition)position;
+(BOOL)ru_cameraDeviceIsAvailableForPosition:(AVCaptureDevicePosition)position;
+(UIImagePickerControllerCameraDevice)ru_UIImagePickerControllerCameraDeviceForPosition:(AVCaptureDevicePosition)position;

@end
