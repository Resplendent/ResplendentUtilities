//
//  UIImage+Resizing.m
//  Memeni
//
//  Created by Sheldon on 10/2/12.
//
//

#import "UIImage+Resizing.h"

#define DEBUG_TIMING 0

@implementation UIImage (Resizing)

UIImage* resizedIfLargerImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize)
{
    if (sourceImage.size.width > targetSize.width || sourceImage.size.height > targetSize.height)
    {
#if DEBUG_TIMING
        NSDate* startDate = [NSDate date];
        NSLog(@"pre resized image %@",NSStringFromCGSize(sourceImage.size));
        UIImage* finalImage = resizedImagePreservingAspectRatio(sourceImage, targetSize);
        NSLog(@"resizedImage size %@ in time %f",NSStringFromCGSize(finalImage.size),[[NSDate date] timeIntervalSinceDate:startDate]);
        return finalImage;
#else
        return resizedImagePreservingAspectRatio(sourceImage, targetSize);
#endif
    }
    else
        return sourceImage;
}

UIImage* resizedImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize)
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

/* Another possible solution:
 + (UIImage *)maskForSize:(CGSize)size cornerRadius:(float)cornerRadius corners:(UIRectCorner)corners
 {
 NSString *(^imageName)(CGSize, float, BOOL, UIRectCorner) = ^(CGSize theSize, float theCornerRadius, BOOL retina, UIRectCorner corners){
 return [NSString stringWithFormat:@"RoundedRectMask_%d_%dx%d_%d_%@.png",
 (int)roundf(theCornerRadius),
 (int)roundf(theSize.width), (int)roundf(theSize.height),
 corners,
 (retina)?@"@2x":@""];
 };
 
 BOOL isRetina = ([UIScreen mainScreen].scale == 2);
 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
 
 UIImage *image = [UIImage imageNamed:imageName(size, cornerRadius, NO, corners)];
 
 if (image == nil)
 {
 NSString *path = [basePath stringByAppendingPathComponent:imageName(size, cornerRadius, NO, corners)];
 image = [UIImage imageWithContentsOfFile:path];
 }
 
 if (image == nil)
 {
 // define our "generate" block
 UIImage *(^generateImage)(CGSize, float, BOOL) = ^(CGSize theSize, float theCornerRadius, BOOL retina){
 UIGraphicsBeginImageContextWithOptions(size, YES, (retina)?2:1);
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGRect rect = (CGRect){0, 0, theSize};
 
 // fill bg white
 [[UIColor whiteColor] setFill];
 CGContextFillRect(context, rect);
 
 // fill rect black
 [[UIColor blackColor] setFill];
 UIBezierPath *path = [UIBezierPath
 bezierPathWithRoundedRect:rect
 byRoundingCorners:corners
 cornerRadii:(CGSize){theCornerRadius, theCornerRadius}];
 [path fill];
 
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 
 UIGraphicsEndImageContext();
 
 return image;
 };
 
 // non retina image, and store
 UIImage *imageNonRetina = generateImage(size, cornerRadius, NO);
 NSString *path = [basePath stringByAppendingPathComponent:imageName(size, cornerRadius, NO, corners)];
 [UIImagePNGRepresentation(imageNonRetina) writeToFile:path atomically:YES];
 
 // retina image and store
 UIImage *imageRetina = generateImage(size, cornerRadius, YES);
 NSString *pathRetina = [basePath stringByAppendingPathComponent:imageName(size, cornerRadius, YES, corners)];
 [UIImagePNGRepresentation(imageRetina) writeToFile:pathRetina atomically:YES];
 
 if (isRetina)
 image = imageRetina;
 else
 image = imageNonRetina;
 }
 
 return image;
 }
 */

@end
