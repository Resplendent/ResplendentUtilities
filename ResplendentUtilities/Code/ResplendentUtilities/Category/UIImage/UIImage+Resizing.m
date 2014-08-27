//
//  UIImage+Resizing.m
//  Resplendent
//
//  Created by Sheldon on 10/2/12.
//
//

#import "UIImage+Resizing.h"
#import "RUConstants.h"





#define UIImage_Resizing_DEBUG_TIMING 0





@implementation UIImage (Resizing)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
