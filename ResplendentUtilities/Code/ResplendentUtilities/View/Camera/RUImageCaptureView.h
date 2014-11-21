//
//  RUImageCaptureView.h
//  Camerama
//
//  Created by Benjamin Maer on 11/20/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUImageCaptureViewProtocols.h"





@interface RUImageCaptureView : UIView

@property (nonatomic, assign) id<RUImageCaptureView_imageCaptureDelegate> imageCaptureDelegate;

@property (nonatomic, assign) BOOL imageCaptureIsRunning; //Shouldn't be used to disable camera streaming. If disabled, cannot capture an image from it.

@property (nonatomic, assign) BOOL enableTapToFocus;
@property (nonatomic, assign) CGSize tapToFocusSize;
@property (nonatomic, strong) UIColor* tapToFocusBorderColor;

-(BOOL)performImageCapture; //Returns TRUE if attempt was made, otherwise FALSE.

@end
