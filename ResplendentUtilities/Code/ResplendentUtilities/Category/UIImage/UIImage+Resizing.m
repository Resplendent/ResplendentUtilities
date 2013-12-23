//
//  UIImage+Resizing.m
//  Albumatic
//
//  Created by Sheldon on 10/2/12.
//
//

#import "UIImage+Resizing.h"
#import "RUConstants.h"

#define UIImage_Resizing_DEBUG_TIMING 0

extern UIImage* resizedImagePreservingAspectRatioWithOrientation(UIImage* sourceImage, CGSize targetSize, UIImageOrientation orientation);
extern UIImage* resizedIfLargerImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize);
extern UIImage* resizedImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize);

@interface UIImage (ResizingUtil)

- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;

@end

@implementation UIImage (Resizing)

#pragma mark - C methods
UIImage* resizedIfLargerImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize)
{
    if (sourceImage.size.width > targetSize.width || sourceImage.size.height > targetSize.height)
    {
#if UIImage_Resizing_DEBUG_TIMING
        NSDate* startDate = [NSDate date];
        NSLog(@"pre resized image %@",NSStringFromCGSize(sourceImage.size));
//        UIImage* finalImage = resizedImagePreservingAspectRatio(sourceImage, targetSize);
        UIImage* finalImage = [sourceImage resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
        NSLog(@"resizedImage size %@ in time %f",NSStringFromCGSize(finalImage.size),[[NSDate date] timeIntervalSinceDate:startDate]);
        return finalImage;
#else
//        return resizedImagePreservingAspectRatio(sourceImage, targetSize);
        return resizedImagePreservingAspectRatio(sourceImage, targetSize);
//        return [sourceImage resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
    #endif
    }
    else
        return sourceImage;
}

UIImage* resizedImagePreservingAspectRatioWithOrientation(UIImage* sourceImage, CGSize targetSize, UIImageOrientation orientation)
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
    
    if (orientation == UIImageOrientationUp || orientation == UIImageOrientationDown)
    {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    else
    {
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

UIImage* resizedImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize)
{
    return resizedImagePreservingAspectRatioWithOrientation(sourceImage, targetSize, sourceImage.imageOrientation);
}

#pragma mark - Public methods
- (UIImage *)resizedImagePreservingAspectRatioIfLargerThanTargetSize:(CGSize)targetSize
{
    return resizedIfLargerImagePreservingAspectRatio(self, targetSize);
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
    BOOL drawTransposed;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

#pragma mark - Private methods
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //create a context to do our clipping in
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);
    
    //draw the image to our clipped context using our offset rect
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    
    //pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    return cropped;
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {

    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        
        default:
            break;
    }
    
    return transform;
}

#pragma mark - Static methods
/* Another possible solution: */
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

@end
