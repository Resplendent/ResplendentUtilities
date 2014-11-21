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

@property (nonatomic, readonly) AVCaptureDeviceInput* deviceVideoInput;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, readonly) AVCaptureStillImageOutput* captureStillImageOutput;

@property (nonatomic, readonly) UIView* tapToFocusView;
@property (nonatomic, readonly) CGRect tapToFocusViewFrame;
@property (nonatomic, readonly) CGRect tapToFocusViewFrame_animation_large;
-(CGRect)tapToFocusViewFrameWithSize:(CGSize)tapToFocusSize;
@property (nonatomic, assign) CGSize tapToFocusSize_animation_large;
@property (nonatomic, assign) BOOL tapToFocusViewVisibility;
@property (nonatomic, assign) CGPoint tapToFocusMiddle;
-(void)updateTapToFocusBorderColor;

@property (nonatomic, readonly) UIView* animatingTapToFocusView;
-(void)performTapToFocusAnimation;
-(void)cancelCurrentAnimatingTapToFocusView;

-(void)focusCameraAtViewPoint:(CGPoint)point;
-(void)focusCameraAtPoint:(CGPoint)point;

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
		_deviceVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&deviceInputError];
		NSAssert(deviceInputError == nil, @"deviceInputError: %@",deviceInputError);
		if ([captureSession canAddInput:self.deviceVideoInput])
		{
			[captureSession addInput:self.deviceVideoInput];
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

	if (self.tapToFocusView)
	{
		[self.tapToFocusView setFrame:self.tapToFocusViewFrame];
		[self.tapToFocusView.layer setCornerRadius:MIN(CGRectGetWidth(self.tapToFocusView.frame),CGRectGetHeight(self.tapToFocusView.frame)) / 2.0f];
	}
}

#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];

	kRUConditionalReturn(self.enableTapToFocus == false, NO);

	[self cancelCurrentAnimatingTapToFocusView];
	[self setTapToFocusViewVisibility:YES];

	UITouch* anyTouch = touches.anyObject;
	[self setTapToFocusMiddle:[anyTouch locationInView:self]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	kRUConditionalReturn(self.enableTapToFocus == false, NO);
	kRUConditionalReturn(self.tapToFocusViewVisibility == false, NO);

	UITouch* anyTouch = touches.anyObject;
	[self setTapToFocusMiddle:[anyTouch locationInView:self]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	kRUConditionalReturn(self.enableTapToFocus == false, NO);
	kRUConditionalReturn(self.tapToFocusViewVisibility == false, NO);
	
	[self setTapToFocusViewVisibility:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	kRUConditionalReturn(self.enableTapToFocus == false, NO);
	kRUConditionalReturn(self.tapToFocusViewVisibility == false, NO);

	UITouch* anyTouch = touches.anyObject;
	CGPoint touchPoint = [anyTouch locationInView:self];
	[self setTapToFocusMiddle:touchPoint];
	[self performTapToFocusAnimation];
	[self focusCameraAtViewPoint:touchPoint];
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

#pragma mark - enableTapToFocus
-(void)setEnableTapToFocus:(BOOL)enableTapToFocus
{
	if (enableTapToFocus)
	{
		if (self.tapToFocusIsSupported == false)
		{
			enableTapToFocus = false;
		}
	}

	kRUConditionalReturn(self.enableTapToFocus == enableTapToFocus, NO);

	_enableTapToFocus = enableTapToFocus;

	if (self.enableTapToFocus == NO)
	{
		[self cancelCurrentAnimatingTapToFocusView];
		[self setTapToFocusViewVisibility:NO];
	}
}

#pragma mark - tapToFocusBorderColor
-(void)setTapToFocusBorderColor:(UIColor *)tapToFocusBorderColor
{
	kRUConditionalReturn(self.tapToFocusBorderColor == tapToFocusBorderColor, NO);

	_tapToFocusBorderColor = tapToFocusBorderColor;

	[self updateTapToFocusBorderColor];
}

#pragma mark - tapToFocusViewVisibility
-(BOOL)tapToFocusViewVisibility
{
	return (self.tapToFocusView != nil);
}

-(void)setTapToFocusViewVisibility:(BOOL)tapToFocusViewVisibility
{
	if (self.enableTapToFocus == false)
	{
		//Can't set tapToFocusViewVisibility to TRUE if enableTapToFocus is FALSE.
		kRUConditionalReturn(tapToFocusViewVisibility == true, YES);
	}

	kRUConditionalReturn(self.tapToFocusViewVisibility == tapToFocusViewVisibility, NO);

	if (tapToFocusViewVisibility)
	{
		if (self.tapToFocusView == nil)
		{
			_tapToFocusView = [UIView new];
			[self.tapToFocusView.layer setBorderWidth:1.0f];
			[self updateTapToFocusBorderColor];
			[self addSubview:self.tapToFocusView];
		}
	}
	else
	{
		if (self.tapToFocusView)
		{
			[self.tapToFocusView removeFromSuperview];
			_tapToFocusView = nil;
		}
	}
}

#pragma mark - Update Content
-(void)updateTapToFocusBorderColor
{
	[self.tapToFocusView.layer setBorderColor:self.tapToFocusBorderColor.CGColor];
}

#pragma mark - Frames
-(CGRect)tapToFocusViewFrame
{
	return [self tapToFocusViewFrameWithSize:self.tapToFocusSize];
}

-(CGRect)tapToFocusViewFrame_animation_large
{
	return [self tapToFocusViewFrameWithSize:self.tapToFocusSize_animation_large];
}

-(CGRect)tapToFocusViewFrameWithSize:(CGSize)tapToFocusSize
{
	CGFloat tapToFocusDimensionLength_half_horizontal = (tapToFocusSize.width / 2.0f);
	CGFloat tapToFocusDimensionLength_half_vertical = (tapToFocusSize.height / 2.0f);

	return (CGRect){
		.origin.x	= self.tapToFocusMiddle.x - tapToFocusDimensionLength_half_horizontal,
		.origin.y	= self.tapToFocusMiddle.y - tapToFocusDimensionLength_half_vertical,
		.size		= tapToFocusSize,
	};
}

-(CGSize)tapToFocusSize_animation_large
{
	static CGFloat const padding_animation_large = 10.0f;

	CGSize tapToFocusSize = self.tapToFocusSize;

	return (CGSize){
		.width		= tapToFocusSize.width + (2.0f * padding_animation_large),
		.height		= tapToFocusSize.height + (2.0f * padding_animation_large),
	};
}

#pragma mark - Setters
-(void)setTapToFocusMiddle:(CGPoint)tapToFocusMiddle
{
	kRUConditionalReturn(CGPointEqualToPoint(self.tapToFocusMiddle, tapToFocusMiddle), NO);

	_tapToFocusMiddle = tapToFocusMiddle;

	[self setNeedsLayout];
}

#pragma mark - Animation
-(void)performTapToFocusAnimation
{
	static NSTimeInterval const duration = 0.5f;

	[self cancelCurrentAnimatingTapToFocusView];

	UIView* tapToFocusView = self.tapToFocusView;
	_tapToFocusView = nil;
	_animatingTapToFocusView = tapToFocusView;

	CGRect tapToFocusViewFrame_animation_large = self.tapToFocusViewFrame_animation_large;
	CGFloat cornerRadius_large = MIN(CGRectGetWidth(tapToFocusViewFrame_animation_large),CGRectGetHeight(tapToFocusViewFrame_animation_large)) / 2.0f;

	[CATransaction begin]; {
		[CATransaction setCompletionBlock:^{
			[tapToFocusView removeFromSuperview];
		}];

		[CATransaction setDisableActions:YES];
		
		[tapToFocusView.layer setCornerRadius:cornerRadius_large];
		[tapToFocusView.layer setBounds:(CGRect){.size = tapToFocusViewFrame_animation_large.size}];
		
		CABasicAnimation *animation_cornerRadius = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
		
		CABasicAnimation *animation_bounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
		
		CAAnimationGroup *animation_group = [CAAnimationGroup animation];
		animation_group.duration = duration;
		animation_group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		animation_group.animations = @[animation_cornerRadius,
									   animation_bounds,
									   ];
		[tapToFocusView.layer addAnimation:animation_group forKey:@"animation_group"];

	}
	[CATransaction commit];
}

-(void)cancelCurrentAnimatingTapToFocusView
{
	kRUConditionalReturn(self.animatingTapToFocusView == nil, NO);
	
	[self.animatingTapToFocusView removeFromSuperview];
	_animatingTapToFocusView = nil;
}

#pragma mark - Focus Camera at point
-(void)focusCameraAtViewPoint:(CGPoint)point
{
	CGPoint translatedPoint = (CGPoint){
		.x	= point.x / CGRectGetWidth(self.bounds),
		.y	= point.y / CGRectGetHeight(self.bounds),
	};

	NSAssert(translatedPoint.x >= 0, @"translatedPoint out of bounds");
	NSAssert(translatedPoint.x <= 1, @"translatedPoint out of bounds");
	NSAssert(translatedPoint.y >= 0, @"translatedPoint out of bounds");
	NSAssert(translatedPoint.y <= 1, @"translatedPoint out of bounds");

	[self focusCameraAtPoint:translatedPoint];
}

-(void)focusCameraAtPoint:(CGPoint)point
{
	kRUConditionalReturn(self.tapToFocusIsSupported == false, YES);
	kRUConditionalReturn(self.enableTapToFocus == false, YES);

	AVCaptureDevice *device = [self.deviceVideoInput device];
	
	NSError* lockError = nil;
	BOOL lockSuccess = [device lockForConfiguration:&lockError];
	
	if (lockSuccess && (lockError == nil))
	{
		[device setFocusPointOfInterest:point];
		
		if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
		{
			[device setFocusMode:AVCaptureFocusModeAutoFocus];
		}
		else
		{
			NSAssert(false, @"AVCaptureFocusModeAutoFocus isn't supported.");
		}
		
		[device unlockForConfiguration];
	}
	else
	{
		NSAssert(false, @"unhandled lockError %@",lockError);
	}
}

#pragma mark - Getters
-(BOOL)tapToFocusIsSupported
{
	return self.deviceVideoInput.device.isFocusPointOfInterestSupported;
}

@end
