//
//  UIInterfaceOrientation+RUUtil.h
//  Camerama
//
//  Created by Benjamin Maer on 11/21/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>





extern CGAffineTransform ru_CGAffineTransformForOrientation(UIInterfaceOrientation orientation);

extern AVCaptureVideoOrientation ru_AVCaptureVideoOrientationForOrientation(UIInterfaceOrientation interfaceOrientation);

extern UIImageOrientation ru_UIImageOrientationFromInterfaceOrientation(UIInterfaceOrientation interfaceOrientation);
