//
//  CMDeviceMotion+RUOrientation.h
//  Camerama
//
//  Created by Benjamin Maer on 11/21/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>





@interface CMDeviceMotion (RUOrientation)

-(UIInterfaceOrientation)ru_UIInterfaceOrientation;

//gravityTolerance should be between 0 and 1
//Returns UIInterfaceOrientationUnknown if gravity values are under the tolerance.
-(UIInterfaceOrientation)ru_UIInterfaceOrientationWithGravityTolerance:(double)gravityTolerance;
+(UIInterfaceOrientation)ru_UIInterfaceOrientationFromGravityX:(double)gravityX gravityY:(double)gravityY gravityTolerance:(double)gravityTolerance;

-(CGAffineTransform)ru_CGAffineTransform;

@end
