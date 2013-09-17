//
//  UIImage+Rotation.h
//  Everycam
//
//  Created by Benjamin Maer on 11/23/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import <UIKit/UIKit.h>

extern UIImage* rotatedImage(UIImage* src, UIImageOrientation orientation);

@interface UIImage (Rotation)

-(UIImage*)rotatedImageToOrientation:(UIImageOrientation)orientation;

@end
