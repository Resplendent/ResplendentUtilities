//
//  UIImage+Resizing.h
//  Albumatic
//
//  Created by Sheldon on 10/2/12.
//
//

#import <UIKit/UIKit.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

extern UIImage* resizedImagePreservingAspectRatioWithOrientation(UIImage* sourceImage, CGSize targetSize, UIImageOrientation orientation);
extern UIImage* resizedIfLargerImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize);
extern UIImage* resizedImagePreservingAspectRatio(UIImage* sourceImage, CGSize targetSize);

@interface UIImage (Resizing)
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
@end
