//
//  AVCaptureDevice+RUCaptureDevices.m
//  Camerama
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "AVCaptureDevice+RUCaptureDevices.h"
#import "RUConditionalReturn.h"





@implementation AVCaptureDevice (RUCaptureDevices)

+(AVCaptureDevice *)ru_captureDeviceForPosition:(AVCaptureDevicePosition)position
{
	kRUConditionalReturn_ReturnValueNil([self ru_cameraDeviceIsAvailableForPosition:position] == false, NO);

	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) {
		if ([device position] == position) {
			return device;
		}
	}
	
	return nil;
}

+(BOOL)ru_cameraDeviceIsAvailableForPosition:(AVCaptureDevicePosition)position
{
	return [UIImagePickerController isCameraDeviceAvailable:[self ru_UIImagePickerControllerCameraDeviceForPosition:position]];
}

+(UIImagePickerControllerCameraDevice)ru_UIImagePickerControllerCameraDeviceForPosition:(AVCaptureDevicePosition)position
{
	switch (position)
 {
  case AVCaptureDevicePositionBack:
			return UIImagePickerControllerCameraDeviceRear;

  case AVCaptureDevicePositionFront:
			return UIImagePickerControllerCameraDeviceFront;

	 case AVCaptureDevicePositionUnspecified:
			break;
	}

	NSAssert(false, @"unhandled");
	return UIImagePickerControllerCameraDeviceRear;
}

@end
