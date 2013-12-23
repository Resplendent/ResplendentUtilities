//
//  UIImage+Resizing.h
//  Albumatic
//
//  Created by Sheldon on 10/2/12.
//
//

#import <UIKit/UIKit.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface UIImage (Resizing)
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImagePreservingAspectRatioIfLargerThanTargetSize:(CGSize)targetSize;
@end
