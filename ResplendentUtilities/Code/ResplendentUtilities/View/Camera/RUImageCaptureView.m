//
//  RUImageCaptureView.m
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import "RUImageCaptureView.h"
#import "AVCaptureOutput+RUGetAVCaptureConnection.h"
#import <AVFoundation/AVFoundation.h>





@interface RUImageCaptureView ()

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, readonly) AVCaptureStillImageOutput* captureStillImageOutput;

@end





@implementation RUImageCaptureView

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		//AV session
		AVCaptureSession* captureSession = [AVCaptureSession new];
		[captureSession setSessionPreset:AVCaptureSessionPresetLow];
		
		AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		
		NSError* deviceInputError = nil;
		AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&deviceInputError];
		NSAssert(deviceInputError == nil, @"deviceInputError: %@",deviceInputError);
		if ([captureSession canAddInput:deviceInput])
		{
			[captureSession addInput:deviceInput];
		}
		else
		{
			NSAssert(false, @"can't handle it");
		}
		
		_previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
		[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
		
		CALayer *rootLayer = self.layer;
		[rootLayer setMasksToBounds:YES];
		[rootLayer addSublayer:self.previewLayer];

		//Output
		_captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
		NSDictionary *outputSettings =
		@{
		  AVVideoCodecKey	: AVVideoCodecJPEG,
		  };
		[self.captureStillImageOutput setOutputSettings:outputSettings];
		
		[captureSession addOutput:self.captureStillImageOutput];
		
		
		//Session preset
		if ([captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto])
		{
			[captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
		}
		else
		{
			NSAssert(false, @"unhandled");
		}

		[self setImageCaptureIsRunning:YES];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.previewLayer setFrame:self.bounds];
}

#pragma mark - Image capture
-(BOOL)performImageCapture
{
	AVCaptureConnection *videoConnection = [self.captureStillImageOutput ru_getAVCaptureConnectionWithPortMediaType:AVMediaTypeVideo];
	kRUConditionalReturn_ReturnValueFalse(videoConnection == nil, YES);
	
	__weak typeof(self) weakSelf = self;

	[self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {

		if (weakSelf)
		{
			if ((error == nil) && (imageSampleBuffer != nil))
			{
				NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
				UIImage *image = [UIImage imageWithData:imageData];

				// add photo metadata (ie EXIF: Aperture, Brightness, Exposure, FocalLength, etc)
				NSDictionary *metadata = (__bridge NSDictionary *)CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageSampleBuffer, kCMAttachmentMode_ShouldPropagate);

				[weakSelf.imageCaptureDelegate ruImageCaptureView:self didCaptureImage:image metaData:metadata];
			}
			else
			{
				[weakSelf.imageCaptureDelegate ruImageCaptureView:self didFailCaptureImageCaptureWithError:error];
			}
		}

	}];

	return TRUE;
}

#pragma mark - imageCaptureIsRunning
-(BOOL)imageCaptureIsRunning
{
	return self.previewLayer.session.isRunning;
}

-(void)setImageCaptureIsRunning:(BOOL)imageCaptureIsRunning
{
	kRUConditionalReturn(self.imageCaptureIsRunning == imageCaptureIsRunning, NO)

	if (imageCaptureIsRunning)
	{
		[self.previewLayer.session startRunning];
	}
	else
	{
		[self.previewLayer.session stopRunning];
	}
}

@end
