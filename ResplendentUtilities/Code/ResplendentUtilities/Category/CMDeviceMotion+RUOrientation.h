//
//  CMDeviceMotion+RUOrientation.h
//  Camerama
//
//  Created by Benjamin Maer on 11/21/14.
//  Copyright (c) 2014 Camerama. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>





@interface CMDeviceMotion (RUOrientation)

-(UIInterfaceOrientation)ru_UIInterfaceOrientation;
-(CGAffineTransform)ru_CGAffineTransform;

@end
