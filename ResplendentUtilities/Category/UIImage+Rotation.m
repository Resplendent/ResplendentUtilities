//
//  UIImage+Rotation.m
//  Everycam
//
//  Created by Benjamin Maer on 11/23/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "UIImage+Rotation.h"

UIImage* rotatedImage(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context=(UIGraphicsGetCurrentContext());
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90/180*M_PI) ;
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90/180*M_PI);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 90/180*M_PI);
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@implementation UIImage (Rotation)

-(UIImage*)rotatedImageToOrientation:(UIImageOrientation)orientation
{
    return rotatedImage(self, orientation);
}

@end
